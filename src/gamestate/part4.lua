local p = (require 'gamestate._level')()
p.activateArrows()

function p:draw()
  p.paper()
  p.sea()
  p.barrel(false)
  p.border()

end

return p
