local p = (require 'gamestate._level')()
p.activateArrows()

function p:draw()
  p.paper()
  p.sea()
  p.barrel()
  p.border()

  p.title("none of the places i floated had mommies.")

end

return p
