-- ~~ dnd ~~
-- drone & drama port
-- 3xsinfb & noise
-- thanks to: @bjc01
-- port by: @cfd90

local ez = include "lib/ezscript"

engine.name = "DND"

function init()
  -- Setup ezscript.
  ez.auto_refresh = true
  
  ez.init({
    { name = "osc 1", e1 = "osc1Freq",   e2 = "osc1Fb",    e3 = "osc1Amp" },
    { name = "osc 2", e1 = "osc2Freq",   e2 = "osc2Fb",    e3 = "osc2Amp" },
    { name = "osc 3", e1 = "osc3Freq",   e2 = "osc3Fb",    e3 = "osc3Amp" },
    { name = "osc *", e1 = "oscSlop",    e2 = nil,         e3 = nil },
    { name = "noise", e1 = "filterFreq", e2 = "filterRes", e3 = "noiseAmp"}
  })
  
  -- Setup params.
  params:add_separator("osc 1")
  
  params:add_control("osc1Amp", "osc 1 amp", controlspec.new(0.0, 1, 'lin', 0.01, 0, '', 1/500))
  params:set_action("osc1Amp", function(x) engine.osc1Amp(x) end)
  
  params:add_control("osc1Freq", "osc 1 freq", controlspec.new(1, 2000, 'exp', 0.01, 55, 'hz', 1/500))
  params:set_action("osc1Freq", function(x) engine.osc1Freq(x) end)
  
  params:add_control("osc1Fb", "osc 1 fb", controlspec.new(0.0, 4, 'lin', 0.01, 0, '', 1/500))
  params:set_action("osc1Fb", function(x) engine.osc1Fb(x) end)
  
  params:add_separator("osc 2")
  
  params:add_control("osc2Amp", "osc 2 amp", controlspec.new(0.0, 1, 'lin', 0.01, 0, '', 1/500))
  params:set_action("osc2Amp", function(x) engine.osc2Amp(x) end)
  
  params:add_control("osc2Freq", "osc 2 freq", controlspec.new(1, 2000, 'exp', 0.01, 110, 'hz', 1/500))
  params:set_action("osc2Freq", function(x) engine.osc2Freq(x) end)
  
  params:add_control("osc2Fb", "osc 2 fb", controlspec.new(0.0, 4, 'lin', 0.01, 0, '', 1/500))
  params:set_action("osc2Fb", function(x) engine.osc2Fb(x) end)
  
  params:add_separator("osc 3")
  
  params:add_control("osc3Amp", "osc 3 amp", controlspec.new(0.0, 1, 'lin', 0.01, 0, '', 1/500))
  params:set_action("osc3Amp", function(x) engine.osc3Amp(x) end)
  
  params:add_control("osc3Freq", "osc 3 freq", controlspec.new(1, 2000, 'exp', 0.01, 220, 'hz', 1/500))
  params:set_action("osc3Freq", function(x) engine.osc3Freq(x) end)
  
  params:add_control("osc3Fb", "osc 3 fb", controlspec.new(0.0, 4, 'lin', 0.01, 0, '', 1/500))
  params:set_action("osc3Fb", function(x) engine.osc3Fb(x) end)
  
  params:add_separator("osc *")
  
  params:add_control("oscSlop", "osc * slop", controlspec.new(0, 100, 'lin', 0.01, 0, '', 1/500))
  params:set_action("oscSlop", function(x) engine.oscSlop(x) end)
  
  params:add_separator("noise")

  params:add_control("noiseAmp", "noise amp", controlspec.new(0.0, 1, 'lin', 0.01, 0.00, '', 1/500))
  params:set_action("noiseAmp", function(x) engine.noiseAmp(x) end)
  
  params:add_control("filterFreq", "filter freq", controlspec.new(1, 10000, 'exp', 0.01, 200, 'hz', 1/500))
  params:set_action("filterFreq", function(x) engine.filterFreq(x) end)
  
  params:add_control("filterRes", "filter res", controlspec.new(0.1, 3.95, 'exp', 0.01, 0.2, '', 1/500))
  params:set_action("filterRes", function(x) engine.filterRes(x) end)
  
  params:bang()
  
  -- Setup MIDI.
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
          params:set("osc1Fb", pct * 4)
        elseif cc == 4 then
          params:set("osc1Amp", pct * 1)
        elseif cc == 5 then
          params:set("osc2Freq", pct * 2000)
        elseif cc == 6 then
          params:set("osc2Fb", pct * 4)
        elseif cc == 8 then
          params:set("osc2Amp", pct * 1)
        elseif cc == 9 then
          params:set("osc3Freq", pct * 2000)
        elseif cc == 10 then
          params:set("osc3Fb", pct * 4)
        elseif cc == 12 then
          params:set("osc3Amp", pct * 1)
        elseif cc == 13 then
          params:set("filterFreq", pct * 10000)
        elseif cc == 14 then
          params:set("filterRes", pct * 3.9)
        elseif cc == 16 then
          params:set("noiseAmp", pct * 1)
        end
      end
    end
  end
end