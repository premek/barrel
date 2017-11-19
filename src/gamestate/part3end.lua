local p = (require 'gamestate._level')()


function p:draw()
  p.clear()
  p.titleMiddle("A whirlpool!")
end
p.keypressed = p.enterToNextLevel


return p
