-- ~~ dnd/classic ~~
-- drone & drama port
-- 3xsinfb & noise
--
-- by: @cfd90
-- thanks to: barry cullen

local ez = include "lib/ezscript"
local dnd = include "lib/engine_dnd"

engine.name = "DND"

function init()
  -- Setup ezscript.
  ez.auto_refresh = true
  
  ez.init({
    { name = "osc 1", e1 = "osc1Freq",   e2 = "osc1Fb",    e3 = "osc1Amp" },
    { name = "osc 2", e1 = "osc2Freq",   e2 = "osc2Fb",    e3 = "osc2Amp" },
    { name = "osc 3", e1 = "osc3Freq",   e2 = "osc3Fb",    e3 = "osc3Amp" },
    { name = "osc *", e1 = "oscSlop",    e2 = "oscMod",    e3 = nil },
    { name = "noise", e1 = "filterFreq", e2 = "filterRes", e3 = "noiseAmp"}
  })

  -- Setup params.
  dnd.add_params()
  params:bang()
  
  -- Setup MIDI Fighter Twister integration.
  local midi_devices = {}
  
  for i=1,16 do
    midi_devices[i] = midi.connect(i)
    local dev = midi_devices[i]
    
    if dev ~= nil and string.lower(dev.name) == "midi fighter twister" and dev.device ~= nil then
      print("discovered mft on port " .. i)
      
      dev.event = function(data)
        local msg = midi.to_msg(data)
      
        if msg.type ~= "cc" then
          return
        end
        
        local cc = msg.cc + 1
        local val = msg.val
        local pct = val / 127
        
        if cc == 1 then
          params:set("osc1Freq", pct * 2000)
        elseif cc == 2 then
          params:set("osc1FreqFine", (pct * 20) - 10)
        elseif cc == 3 then
          params:set("osc1Fb", pct * 4)
        elseif cc == 4 then
          params:set("osc1Amp", pct * 1)
        elseif cc == 5 then
          params:set("osc2Freq", pct * 2000)
        elseif cc == 6 then
          params:set("osc2FreqFine", (pct * 20) - 10)
        elseif cc == 7 then
          params:set("osc2Fb", pct * 4)
        elseif cc == 8 then
          params:set("osc2Amp", pct * 1)
        elseif cc == 9 then
          params:set("osc3Freq", pct * 2000)
        elseif cc == 10 then
          params:set("osc3FreqFine", (pct * 20) - 10)
        elseif cc == 11 then
          params:set("osc3Fb", pct * 4)
        elseif cc == 12 then
          params:set("osc3Amp", pct * 1)
        elseif cc == 13 then
          params:set("filterFreq", pct * 10000)
        elseif cc == 14 then
          params:set("filterRes", pct * 3.9)
        elseif cc == 15 then
          params:set("oscMod", pct * 1000)
        elseif cc == 16 then
          params:set("noiseAmp", pct * 1)
        end
      end
    end
  end
end