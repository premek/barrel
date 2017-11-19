local p = (require 'gamestate._level')()


function p:draw()
  p.clear()
  p.titleMiddle("Part 3")
end
p.keypressed = p.enterToNextLevel


return p
