require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'
require_relative 'lib/puts_slow'

p1 = Player.new("Carapuce")
p2 = Player.new("Salamèche")

p1.show_state
p2.show_state
puts_slow ""

count = 0
while !p1.dead && !p2.dead
  count += 1
  puts_slow "-------ROUND #{count}"
  p1.attacks(p2)
  if !p2.dead # si p2 n'est pas mort
    p2.attacks(p1)
  end
  puts_slow "-------"
end
puts_slow "FIN DU JEU"
# binding.pry
