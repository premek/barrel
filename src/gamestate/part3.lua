local p = (require 'gamestate._level')()
p.activateArrows()

function p:draw()
  p.paper()
  p.sea()
  p.barrel()
  p.whirlpool()
  p.border()

  p.title("wow!")

end

return p
