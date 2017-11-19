local p = (require 'gamestate._level')()


function p:draw()
  p.clear()
  p.titleMiddle("Part 1")
end
p.keypressed = p.enterToNextLevel


return p
