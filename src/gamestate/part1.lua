local p = (require 'gamestate._level')()
p.activateArrows()

function p:draw()
  p.paper()
  p.sea()
  p.barrel()
  p.border()

  p.title("i wonder where i'll float next?")

end

return p
