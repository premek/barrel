local p = (require 'gamestate._level')()


function p:draw()
  p.clear()
  p.titleMiddle("Awww.")
end
p.keypressed = p.enterToNextLevel


return p
