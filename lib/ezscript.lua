-- ezscript
-- by: @cfd90
--
-- tiny lib for quickly building a text-based norns ui
--

local key1_held = false

local ez = {}

-- current page
ez.page = 1

-- each page should be of form: { name = "string", e1 = "param string id", e2 = ..., e3 = ... }
ez.pages = {}

-- whether or not to show param values
ez.show_values = true

-- whether or not to show page counts
ez.show_page_counts = true

-- string to display for unused encoder
ez.unused_encoder_str = "-"

-- whether or not to refresh UI automatically
ez.auto_refresh = false

ez.init = function(pages)
  -- Configure pages
  ez.pages = pages
  
  -- Setup auto refresh if needed.
  if ez.auto_refresh then
    ez.ui_metro = metro.init()
    ez.ui_metro.time = 1/15
    ez.ui_metro.event = function()
      redraw()
    end
  
    ez.ui_metro:start()
  end
end

local function draw_encoder_param(p)
  if p ~= nil then
    screen.level(15)
    screen.text(params:lookup_param(p).name .. (ez.show_values and ": " or ""))
    
    if ez.show_values then
      screen.level(5)
      screen.text(params:string(p))
    end
  else
    screen.level(1)
    screen.text(ez.unused_encoder_str)
  end
end

function redraw()
  local p = ez.pages[ez.page]
  
  screen.clear()
  screen.aa(0)
  
  screen.level(15)
  screen.move(0, 10)
  screen.text(p.name)
  
  if ez.show_page_counts then
    screen.move(124, 10)
    screen.text_right(" (" .. ez.page .. "/" .. #ez.pages .. ")")
  end
  
  screen.move(10, 30)
  draw_encoder_param(p.e1)
  
  screen.move(10, 40)
  draw_encoder_param(p.e2)
  
  screen.move(10, 50)
  draw_encoder_param(p.e3)
  
  screen.update()
end

function enc(n, d)
  local p = ez.pages[ez.page]
  local amount
  
  if key1_held then
    amount = d / 10
  else
    amount = d
  end
  
  if n == 1 then
    if p.e1 ~= nil then
      params:delta(p.e1, amount)
    end
  elseif n == 2 then
    if p.e2 ~= nil then
      params:delta(p.e2, amount)
    end
  elseif n == 3 then
    if p.e3 ~= nil then
      params:delta(p.e3, amount)
    end
  end
  
  redraw()
end

function key(n, z)
  if n == 1 and z == 1 then
    key1_held = true
  elseif n == 1 and z == 0 then
    key1_held = false
  end
  
  if z == 1 then
    if n == 2 then 
      ez.page = util.clamp(ez.page - 1, 1, #ez.pages)
    elseif n == 3 then
      ez.page = util.clamp(ez.page + 1, 1, #ez.pages)
    end
  end
  
  redraw()
end

return ez