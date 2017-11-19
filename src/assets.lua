-- assets are loaded when this is require'd first time
-- when it is required again, the same table is returned with the content that was already loaded before
-- TODO make it more library-like

local Timer = require 'lib.hump.timer'

local love = love

local a = {
  music = {},
  img = {},
  sfx = {},
  font = {}
}

a.volumes = {}

a.music[1] = love.audio.newSource( 'music/part1intro.mp3', 'stream' )
a.music[1]:setLooping(false)
a.volumes[1] = 1

a.music[2] = love.audio.newSource( 'music/borealism x [ocean jams] -  kill-it.mp3', 'stream' )
a.music[2]:setLooping(true)
a.volumes[2] = 1

a.music[3] = love.audio.newSource( 'music/premek-stick_guitar.mp3', 'stream' )
a.music[3]:setLooping(true)
a.volumes[3] = 4

a.music[4] = love.audio.newSource( 'music/xavfalcon-late-nights.mp3', 'stream' )
a.music[4]:setLooping(true)
a.volumes[4] = 1

a.music[5] = love.audio.newSource( 'music/borealism-glider.mp3', 'stream' )
a.music[5]:setLooping(false)
a.volumes[5] = 1.5

a.music.volume = 1
a.music.fadein = 1
a.music.fadeout = 2
a.music.current = nil

a.music.play = function (i)
  print(i)

  if i ~= 'stop' and (not a.music[i] or a.music[i]:isPlaying()) then return end
  local out = (a.music.current and a.music.current:isPlaying()) and a.music.fadeout or 0
  Timer.tween(out, a.music, {volume=0}, 'out-quad', function ()
    if a.music.current then a.music.current:pause() end
    if i ~= 'stop' then
      a.music.current = a.music[i]
      a.music.current:play()
      Timer.tween(a.music.fadein, a.music, {volume=a.volumes[i]}, 'out-quad')
    end
  end)

  Timer.during(a.music.fadeout + a.music.fadein + .2, function(dt)
    if a.music.current then a.music.current:setVolume(a.music.volume) end
  end)

end


a.font.comic = love.graphics.newFont( "ShadowsIntoLight.ttf", 25 )
a.font.big = love.graphics.newFont( "ShadowsIntoLight.ttf", 50)

return a
