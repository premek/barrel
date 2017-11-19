local p = (require 'gamestate._level')()
local Signal = require 'lib.hump.signal'

function p:draw()
  p.paper()
  p.sky(235, 82, 16)
  p.sea(89, 116, 194, false)
  p.fly(function () Signal.emit('next_level') end)
  p.border()

end

return p
