require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

p1 = HumanPlayer.new("Carapuce")
p2 = HumanPlayer.new("Salamèche")

p1.show_state
p2.show_state
puts ""

count = 0
while !p1.dead && !p2.dead
  count += 1
  puts "-------ROUND #{count}"
  p1.attacks(p2)
  if !p2.dead # si p2 n'est pas mort
    p2.attacks(p1)
  end
  puts "-------"
end
puts "FIN DU JEU"
# binding.pry
