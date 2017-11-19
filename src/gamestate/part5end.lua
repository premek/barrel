local p = (require 'gamestate._level')()


function p:draw()
  p.clear()
  p.titleMiddle("Too good not to happen.")
end
p.keypressed = p.enterToNextLevel


return p
