local Signal = require 'lib.hump.signal'
local assets = require 'assets'
local level = (require 'gamestate._level')()

local love = love
local lg = love.graphics
local lgw, lgh
local pad = 100

local p = {}

function p:update (dt)
  lgw = lg.getWidth()
  lgh = lg.getHeight()
end

function p:draw()
  lg.setColor(255,255,255)
  lg.rectangle('fill', 0,0,lgw, lgh)
  lg.setColor(0,0,0)
  lg.setFont(assets.font.big)
  lg.printf("Barrel", 0, 120, lgw, 'center')
  lg.setFont(assets.font.comic)
  lg.printf("Use right arrow to control the barrel.\nPress enter to continue.\nListen.", pad,  280, lgw-pad*2, 'center')

end

p.keypressed = level.enterToNextLevel


return p
