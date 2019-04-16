require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'
require_relative 'lib/puts_slow'

puts_slow "------------------------------------------------
|Bienvenue sur 'ILS VEULENT TOUS MA POO' !      |
|Le but du jeu est d'être le dernier survivant !|
-------------------------------------------------"

puts_slow "Quel est ton nom de guerre ?"
print ">>"
player = HumanPlayer.new(gets.chomp.to_s)
puts_slow ""

def random_name
  ["Carapuce", "Salamèche", "Bulbizarre", "Lipoutou",
  "Grotadmorv", "Sacdenoeud", "DSK", "Racaillou"].sample
end

def create_enemies (number)
  arr = []
  number.times {
    name = random_name
    used_names = arr.map {|e| e.name}
    while used_names.include?(name)
      name = random_name
    end
    bot = Player.new(random_name)
    arr << bot
    puts_slow "Un #{bot.name} sauvage apparaît !!"
  }
  arr
end

def player_action (player, enemies)
  action = nil
  until ["a","b","c"].include?(action)
    puts_slow "Que vas tu faire ?
    a - attaquer
    b - chercher une arme
    c - chercher une potion"
    print ">>"
    action = gets.chomp.to_s
    if !["a","b","c"].include?(action)
      puts_slow "... je n'ai pas compris, a b ou c..."
    end
  end
  case action
  when "a"
    action = nil
    until (0..(enemies.length-1)).to_a.include?(action)
      puts_slow "Quel ennemi attaquer ?"
      for ix in 0..(enemies.length-1)
        e = enemies[ix]
        puts_slow "#{ix} - #{e.name} qui a #{e.hp} points de vie ?"
      end
      print ">>"
      action = gets.chomp.to_i
      if !(0..(enemies.length-1)).to_a.include?(action)
        puts_slow "... je n'ai pas compris, tape l'index de l'ennemi..."
      end
    end
    player.attacks(enemies[action])
  when "b"
    player.search_weapon
  when "c"
    player.search_health_pack
  end
end

enemies = create_enemies (2)
puts_slow ""
count = 0
until player.dead || enemies.select{|e| e.dead} == enemies
  count +=1
  puts_slow "<<<<<<<< ROUND #{count} >>>>>>>>>"
  player.show_state
  enemies.each {
    |e|
    e.show_state
  }
  player_action(player, enemies)
  enemies.each {
    |e|
    if !e.dead
      e.attacks(player)
    end
  }
end

puts_slow ">>>fin de la partie"
puts_slow player.dead ? "... tu as perdu" : "BRAVO tu as gagné !!!
voilà le badge #{["PIERRE","EAU","FEU","AIR"].sample}"
