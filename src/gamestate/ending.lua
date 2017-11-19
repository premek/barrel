local p = (require 'gamestate._level')()


function p:draw()
  p.clear()
  p.titleScroll("An #xkcdGameJam game\nbased on the Barrel (Parts 1-5) xkcd comic.\n"..
  "Made by @Premek_V (https://premek.itch.io/) in 3 days\n"..
  "using LÖVE Game Engine.\n"..
  "Original comic: Randall Munroe.\n"..
  "Soundtrack: Borealism, Premek_V, kuuma.\n"..
  "\n"..
  "\n"..
  "Thanks for playing\n"
)
end


return p
