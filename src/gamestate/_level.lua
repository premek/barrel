local assets = require 'assets'
local Signal = require 'lib.hump.signal'

local love = love
local lg = love.graphics
local lk = love.keyboard

local lgw, lgh, seaLevel,bar, wh

local pad = 70
local bpad = 50
local sq = 26.5
local speed
local flyTime = 60

return function()
local p = {}


local function resize()
  lgw = lg.getWidth()
  lgh = lg.getHeight()
  seaLevel = pad + math.floor((lgh-pad)/sq*0.55)*sq
  bar.y = seaLevel-10
  speed = lgw/80
  wh.x = lgw
  wh.y = bar.y*bar.a+bar.h*bar.a

end


function p:init()

bar = {
x = 0,
y = 0,
w = 60,
h = 60,
a = 4,
r = 0
}

wh = {
x = 0,
y = 0,
d = 0,
r = 0
}

resize()




bar.x = pad + lgw*0.1

end

function p:resume ()
end

function p:enter ()
end



local t = 0
local arrowsActive = false

function p:update(dt)
  t=t+dt+0
  resize()
  bar.r = math.sin(t)*6
  wh.r = (t*70)%360
  if arrowsActive and lk.isDown('right') then bar.x = bar.x + dt*speed; bar.r=bar.r-0; end
  --if arrowsActive and lk.isDown('left') then bar.x = bar.x - dt*speed; bar.r=bar.r+2 end
  if bar.x > lgw-pad or bar.x < pad then Signal.emit('next_level') end
end



function p.activateArrows()
  arrowsActive = true
end

function p:keypressed(key)
end



function p.clear()
lg.setColor(255,255,255)
lg.rectangle('fill', 0,0,lgw, lgh)
end

function p.paper ()
  p:clear()
  lg.setLineWidth(1)
  lg.setColor(213, 220, 218)
  for i=pad,lgw-pad, sq do
    lg.line(i, pad, i, lgh-pad-bpad)
  end
  for i=pad,lgh-pad-bpad, sq do
    lg.line(pad, i, lgw-pad, i)
  end
end

function p.border ()
  lg.setColor(255,255,255)
  lg.rectangle('fill', 0,0,lgw, pad)
  lg.rectangle('fill', lgw-pad,0,pad, lgh)
  lg.rectangle('fill', 0,lgh-pad-bpad,lgw, pad+bpad)
  lg.rectangle('fill', 0,0,pad, lgh)
  lg.setLineWidth(8)
  lg.setColor(0,0,0)
  lg.rectangle('line', pad, pad, lgw-pad*2, lgh-pad*2-bpad)
end

function p.sky (r, g, b)
  local st = sq/5
  lg.setLineWidth(1)
  local dark = seaLevel
  local light = seaLevel-sq*5
  for y=light, dark, st do
    local shd = (y-dark) / (light-dark)
    lg.setColor(r or 0, g or 0, b or 0, (1-shd)*255)
    lg.line(pad, y, lgw-pad, y)
  end

end

function p.sea (r, g, b, barrel)
  if barrel == nil then barrel = true end
  local gapl = barrel and bar.x or 0
  local gapr = barrel and bar.x+bar.w or 0

  lg.setLineWidth(4)
  lg.setColor(0,0,0)
  lg.line(pad, seaLevel, gapl, seaLevel)
  lg.line(gapr, seaLevel, lgw-pad, seaLevel)

  lg.setLineWidth(1)
  local st = sq/5
  local dark = seaLevel + st
  local light = seaLevel+sq*2
  for y=dark, light, st do
    local shd = (y-dark) / (light-dark)
    lg.setColor(r or 0, g or 0, b or 0, (1-shd)*255)
    lg.line(pad, y, gapl, y)
    lg.line(gapr, y, lgw-pad, y)
  end

end

function p.barrel (boy)
  if boy == nil then boy=true end
  lg.push()
  lg.translate(bar.x+bar.w/2, bar.y+30)
  lg.rotate(math.pi/180*bar.r)
  lg.translate(-(bar.x+bar.w/2), -(bar.y+30))

  lg.setLineWidth(5)
  lg.setColor(0,0,0)
  lg.line(bar.x, bar.y, bar.x, bar.y+bar.h)
  lg.line(bar.x+bar.w, bar.y, bar.x+bar.w, bar.y+bar.h)
  lg.push()
  lg.scale(1, 1/bar.a)
  lg.setLineWidth(bar.a*1.8)
  lg.arc('line', bar.x+bar.w/2, bar.y*bar.a, bar.w/2, 0, math.pi*2)
  lg.arc('line', 'open', bar.x+bar.w/2, (bar.y+bar.h*0.45)*bar.a, bar.w/2, 0, math.pi)
  lg.arc('line', 'open', bar.x+bar.w/2, (bar.y+bar.h*0.9)*bar.a, bar.w/2, 0, math.pi)
  lg.arc('line', 'open', bar.x+bar.w/2, (bar.y+bar.h)*bar.a, bar.w/2, 0, math.pi)
  lg.pop()

 if boy then
  lg.setLineWidth(2)
  local neckx = bar.x+bar.w/2
  local necky = bar.y-40 -- haha, necky
  local headr = 20
  lg.line(neckx, necky, neckx, necky+47.5)
  lg.line(neckx, necky, neckx-15, necky+47.5)
  lg.line(neckx, necky, neckx+15, necky+47.5)
  lg.circle('line', neckx, necky-headr, headr)
 end

  lg.pop()

end

function p.whirlpool ()

  lg.setColor(0,0,0)


  lg.push()
  lg.scale(1, 1/bar.a)

  lg.push()
  lg.translate(wh.x, wh.y)
  lg.rotate(math.pi/180*wh.r)
  lg.translate(-wh.x, -wh.y)


  lg.setLineWidth(2)
  for i=1,30 do
    lg.arc('line', 'open', wh.x, wh.y, i*6, i*1.2+i*0.1, i*0.8+i*0.3)
  end
  -- lg.skrrrr()
  lg.pop()
  lg.pop()

end

function p.fly(after)
  if t > flyTime then after() end
  lg.push()
  lg.translate(lgw*0.3, lgh*0.3)
  lg.scale(math.max(0, flyTime/t-1), math.max(0, flyTime/t-1))
  lg.translate(-lgw*0.3, -lgh*0.3)

  lg.setLineWidth(1)
  lg.setColor(0,0,0)

  local neckx = lgw*0.4
  local necky = seaLevel - 100
  local headr = 4
  lg.line(neckx-2, necky, neckx, necky+15) -- body
  lg.line(neckx, necky+15, neckx+5, necky+39) -- rleg
  lg.line(neckx, necky+15, neckx-2, necky+40) --lleg
  lg.line(neckx-2, necky, neckx-4, necky+22) --lhand
  lg.line(neckx-2, necky, neckx+4, necky-22) --rhand
  lg.circle('line', neckx-5, necky-headr, headr)

  lg.setLineWidth(2)
  lg.line(neckx+6-15, necky-22+5, neckx+6+15, necky-22-5)
  lg.line(neckx+6-10, necky-22-4, neckx+6+30, necky-22+12)
  lg.line(neckx+32-6, necky-22+10+2, neckx+32+6, necky-22+10-2)
  lg.line(neckx+32, necky-22+10, neckx+32, necky-22+10-6)

  lg.pop()

end


function p.titleScroll (txt) p.title(txt, lgh-t*18) end
function p.titleMiddle (txt) p.title(txt, 150) end
function p.title (txt, y)
  lg.setFont(assets.font.comic)
  lg.setColor(0,0,0)
  y = y or lgh-bpad-pad*0.8
  lg.printf(txt, pad, y, lgw-pad*2, 'center')
end


function p:enterToNextLevel(key)
  if key=='return' then Signal.emit('next_level') end
end



return p
end
