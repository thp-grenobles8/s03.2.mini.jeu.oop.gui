require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'
require_relative 'lib/puts_slow'


continue = true
count = 0
while continue
  count += 1
  Game.new
  puts_slow "-----------------------------------"
  puts_slow "Veux-tu retenter une partie ?"
  print "\"o\" pour oui>>"
  continue = gets.chomp.to_s == "o"
end

puts_slow "Tu as fait #{count} parties..."
case count
when 1
  puts_slow " => le jeu ne t'a pas plu ??"
when 2..3
  puts_slow " => le jeu t'a plu ?"
else
  puts_slow " => toi tu kiffes le jeu"
end
