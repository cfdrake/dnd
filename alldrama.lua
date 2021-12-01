-- ~~ dnd/alldrama ~~
-- a drum machine for nerds
-- maiden: use p(), f(), r(), s()
--
-- by: @cfd90
-- thanks to: barry cullen

local dnd = include "lib/engine_dnd"

local clk
local pitches = {4, 8, 32, 34, 32, 34}
local feedbacks = {3, 2, 1.9, 0, 1, 1}
local rates = {1, 1, 1, 1, 1, 1}
local idx = 1
local steps = 6

function p(n, v) pitches[n] = v end
function f(n, v) feedbacks[n] = v end
function r(n, v) rates[n] = v end
function s(n) steps = n end

engine.name = "DND"

function init()
  -- Setup params.
  dnd.add_params()
  params:bang()

  -- Setup clock.
  clk = clock.run(tick)
end

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
