class Game
  attr_accessor :player, :enemies

  def initialize (part)
    puts "------------------------------------------------
    |Bienvenue sur 'ILS VEULENT TOUS MA POO' !      |
    |Le but du jeu est d'être le dernier survivant !|
    -------------------------------------------------"
    puts ""
    puts "Quel est ton nom de guerre ?"
    print ">>"
    @player = HumanPlayer.new(gets.chomp.to_s)
    puts ""

    create_enemies(4)
  end

  def kill_bot (bot)
    @enemies.delete(bot)
  end

  def is_still_ongoing?
    @player.dead || @enemies.length > 0
  end

  def show_players
    @player.show_state
    puts "Il reste #{@enemies.length} ennemis !!"
    puts ""
  end

  def menu_main
    action = nil
    until ["a","b","c"].include?(action)
      puts "Que vas tu faire ?
      a - attaquer
      b - chercher une arme
      c - chercher une potion"
      print ">>"
      action = gets.chomp.to_s
      if !["a","b","c"].include?(action)
        puts "... je n'ai pas compris, a b ou c..."
      end
    end
    action
  end

  def menu_attack
    target = nil
    until (0..(@enemies.length-1)).to_a.include?(target)
      puts "Quel ennemi attaquer ?"
      for ix in 0..(@enemies.length-1)
        e = @enemies[ix]
        puts "#{ix} - #{e.name} qui a #{e.hp} points de vie ?"
      end
      print ">>"
      target = gets.chomp
      if !(0..(@enemies.length-1)).to_a.map {
        |i| i.to_s
      }.include?(target)
        puts "... je n'ai pas compris, tape l'index de l'ennemi..."
      end
    end
    target
  end

  def menu_choice (action)
    case action
    when "a"
      target_ix = menu_attack
      target = @enemies[target_ix.to_i]
      @player.attacks(target)
      if target.dead
        kill_bot(target)
      end
    when "b"
      @player.search_weapon
    when "c"
      @player.search_health_pack
    end
  end

  def enemies_attack
    @enemies.each {
      |e|
      e.attacks(player)
    }
  end

  def end_game
    puts ">>>fin de la partie"
    puts @player.dead ? "... tu as perdu" : "BRAVO tu as gagné !!!
voilà ton badge #{["PIERRE","EAU","FEU","AIR"].sample}"
  end

  def random_name
    ["Carapuce", "Salamèche", "Bulbizarre", "Lipoutou",
    "Grotadmorv", "Sacdenoeud", "DSK", "Racaillou"].sample
  end

  def create_enemies (number)
    @enemies = []
    number.times {
      name = random_name
      used_names = arr.map {|e| e.name}
      while used_names.include?(name)
        name = random_name
      end
      bot = Player.new(random_name)
      @enemies << bot
      puts "Un #{bot.name} sauvage apparaît !!"
    }
  end
end
