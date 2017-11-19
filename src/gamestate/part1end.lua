local p = (require 'gamestate._level')()


function p:draw()
  p.clear()
  p.titleMiddle("Don't we all.")
end
p.keypressed = p.enterToNextLevel


return p
