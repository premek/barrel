local assets = require 'assets'
local Gamestate = require "lib.hump.gamestate"
require "lib.require"
local Signal = require 'lib.hump.signal'
local state = require.tree("gamestate")
local Timer = require 'lib.hump.timer'


local state_music = {
[state.part1title]=1,
[state.part1]=2,
[state.part2end]='stop',
[state.part3]=3,
[state.part3end]='stop',
[state.part4]=4,
[state.part4end]='stop',
[state.part5]=5,
}
Signal.register('state_entered', function(stt) assets.music.play(state_music[stt]) end)

local currentLevel = 0
local levels = {
  state.part1title,
  state.part1,
  state.part1end,
  state.part2title,
  state.part2,
  state.part2end,
  state.part3title,
  state.part3,
  state.part3end,
  state.part4title,
  state.part4,
  state.part4end,
  state.part5title,
  state.part5,
  state.part5end,
}

Signal.register('next_level', function()
  currentLevel = currentLevel + 1
  local st = currentLevel > #levels and state.ending or levels[currentLevel]
  Gamestate.switch(st)
  Signal.emit('state_entered', st)
end)
Signal.register('quit', function() love.event.quit() end)



local love = love
local lg = love.graphics

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(state.mainmenu)
  Signal.emit('game_loaded')
end

function love.update(dt)
    Timer.update(dt)

end


function love.draw(dt)

end

function love.keypressed(key)
  Signal.emit('key', key)
  if key=='escape' then Signal.emit('quit') end
end
