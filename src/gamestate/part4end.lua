local p = (require 'gamestate._level')()


function p:draw()
  p.clear()
  p.titleMiddle(": (")
end
p.keypressed = p.enterToNextLevel


return p
