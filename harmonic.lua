-- ~~ dnd/harmonic ~~
-- harmonic controller...
-- connect a grid...
-- 1st four cols: freqs
-- 2nd four cols: amps
--
-- by: @cfd90
-- thanks to: barry cullen

local ez = include "lib/ezscript"
local dnd = include "lib/engine_dnd"

engine.name = "DND"

function init()
    -- Setup ezscript.
  ez.auto_refresh = true
  ez.show_page_title = false
  ez.show_page_counts = false
  
  ez.init({
    { name = "harm", e1 = "oscFbAll", e2 = "oscMod", e3 = "filterRes" }
  })

  -- Setup params.
  dnd.add_params()
  params:bang()
  
  params:add_control("oscFbAll", "osc * fb", controlspec.new(0, 4, 'lin', 0.01, 0, '', 1/500))
  params:set_action("oscFbAll", function(x)
    params:set("osc1Fb", x)
    params:set("osc2Fb", x)
    params:set("osc3Fb", x)
  end)
  params:hide("oscFbAll")
  
  -- Setup grid.
  g = grid.connect()
  
  g:all(0)
  
  for x=1,8 do
    g:led(x, 8, 15)
  end
  
  g:refresh()
  
  g.key = function(x, y, z)
    if z == 0 then
      return
    end
    
    local Y
    
    if y == 8 and x >= 4 then
      Y = 0
    else
      Y = (8 - y) + 1
    end
    
    if x == 1 then
      params:set("osc1Freq", Y * 55)
    elseif x == 2 then
      params:set("osc2Freq", Y * 55)
    elseif x == 3 then
      params:set("osc3Freq", Y * 55)
    elseif x == 4 then
      params:set("filterFreq", Y * 440)
    elseif x == 5 then
      params:set("osc1Amp", Y / 16.0)
    elseif x == 6 then
      params:set("osc2Amp", Y / 16.0)
    elseif x == 7 then
      params:set("osc3Amp", Y / 16.0)
    elseif x == 8 then
      params:set("noiseAmp", Y / 16.0)
    end
    
    for _y=1,8 do
      g:led(x, _y, 0)
    end
    
    g:led(x, y, 15)
    g:refresh()
  end
end