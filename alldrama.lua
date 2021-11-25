-- ~~ all drama ~~
-- a drum machine for nerds
-- by: @cfd90
-- based on:
--     dnd script
-- and in turn:
--       drone & drama

engine.name = "DND"

local clk

function init()
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
  
  clk = clock.run(tick)
end

local pitches = {4, 8, 32, 34, 32, 34}
local feedbacks = {3, 2, 1.9, 0, 1, 1}
local rates = {1, 1, 1, 1, 1, 1}
local idx = 1
local steps = 6

function p(n, v) pitches[n] = v end
function f(n, v) feedbacks[n] = v end
function r(n, v) rates[n] = v end
function s(n) steps = n end

function tick()
  while true do
    local rate = rates[idx]
    clock.sync(1/rate)
    
    params:set("osc1Amp", 0.05)
    params:set("osc1Freq", pitches[idx])
    params:set("osc1Fb", feedbacks[idx])
    
    redraw()
    
    idx = idx + 1
    
    if idx > steps then
      idx = 1
    end
  end
end

function enc(n, d)
  if n == 1 then
    params:delta("clock_tempo", d)
    redraw()
  end
end

function redraw()
  screen.clear()
  
  screen.move(0, 10)
  screen.level(5)
  screen.text("tempo: ")
  screen.level(15)
  screen.text(params:get("clock_tempo"))
  screen.level(5)
  screen.text(" | steps: ")
  screen.level(15)
  screen.text(steps)
  
  screen.move(0, 30)
  screen.level(5)
  
  for i=1, #pitches do
    screen.level(idx == i and 15 or 2)
    screen.move((i * 18), 30)
    screen.text(i)
  end
  
  screen.move(0, 40)
  screen.level(5)
  screen.text("fq: ")
  
  for i=1, #pitches do
    screen.level(idx == i and 15 or 5)
    screen.move((i * 18), 40)
    screen.text(pitches[i])
  end
  
  screen.move(0, 50)
  screen.level(5)
  screen.text("fb: ")
  
  for i=1, #pitches do
    screen.level(idx == i and 15 or 5)
    screen.move((i * 18), 50)
    screen.text(feedbacks[i])
  end
  
  screen.move(0, 60)
  screen.level(5)
  screen.text("rt: ")
  
  for i=1, #pitches do
    screen.level(idx == i and 15 or 5)
    screen.move((i * 18), 60)
    screen.text(rates[i])
  end
  
  screen.update()
end