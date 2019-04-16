class Game
  attr_accessor :player, :enemies, :round_count, :fight_count

  def initialize
    puts_slow "    ------------------------------------------------
    |Bienvenue sur PORNOMON QUEST !                 |
    |Le but du jeu est d'être le dernier survivant !|
    |Prépare toi à rencontrer plein de pornomons    |
    | sauvages dans les broussailles ...            |
    -------------------------------------------------"
    puts_slow ""
    puts_slow "Quel est ton nom de guerre ?"
    print ">>"
    @player = HumanPlayer.new(gets.chomp.to_s)
    puts_slow ""
    @fight_count = 0
    while !player.dead && @fight_count < 4
      fight
    end
    if !@player.dead
      fight(boss = true)
      puts_slow "TU AS GAGNE TOUS LES COMBATS, TE VOILA CHAMPION"
      puts_slow "bravo champion... see you next game"
    else
      puts_slow "... tu es mort, retente ta chance ...."
    end
  end

  def fight (boss = false)
    @fight_count += 1
    @round_count = 0
    if !boss
      puts_slow "<<<<<<<<<<<<< FIGHT #{@fight_count} >>>>>>>>>>>>>>>>>"
      create_enemies(@fight_count)
    else
      puts_slow "!!!!!!!!!!!!! FINAL FIGHT !!!!!!!!!!!!!!!!!!!"
      @enemies << HumanPlayer.new("SACHATTE", skill = 4)
      @enemies[O].hp = 1000
      puts_slow "voila ton dernier ennemi, ta nemesis, pourra tu le vaincre ?"
    end
    puts_slow "(appuie sur une touche pour continuer)"
    gets.chomp
    while !@player.dead && is_still_ongoing?
      round
    end
    end_fight
  end

  def round
    @round_count +=1
    puts_slow "---------- ROUND #{@round_count} ---------"
    show_players
    action = menu_main
    menu_choice(action)
    enemies_attack
  end

  def kill_bot (bot)
    @enemies.delete(bot)
  end

  def is_still_ongoing?
    @player.dead || @enemies.length > 0
  end

  def show_players
    @player.show_state
    puts_slow "Il reste #{@enemies.length} ennemis !!"
    @enemies.each {
      |e|
      e.show_state
    }
    puts_slow ""
  end

  def menu_main
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
    action
  end

  def menu_attack
    target = nil
    indexes = (0..(@enemies.length-1)).to_a.map {
      |i| i.to_s
    }
    until indexes.include?(target)
      puts_slow "Quel ennemi attaquer ?"
      for ix in 0..(@enemies.length-1)
        e = @enemies[ix]
        puts_slow "#{ix} - #{e.name} qui a #{e.hp} points de vie ?"
      end
      puts_slow ""
      print ">>"
      target = gets.chomp.to_s
      if !indexes.include?(target)
        puts_slow "... je n'ai pas compris, tape l'index de l'ennemi..."
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
      if !@player.dead
        e.attacks(player)
      else
        end_fight
      end
    }
  end

  def end_fight
    puts_slow ">>>fin du combat"
    puts_slow ""
    puts_slow @player.dead ? "... tu as perdu" : "BRAVO tu as gagné !!!
voilà ton badge #{["PIERRE","EAU","FEU","AIR"].sample}"
    puts_slow "(appuie sur une touche pour continuer)"
    gets.chomp
  end

  def random_name
    ["Carapute", "Sodomèche", "Vulvizarre", "Ligounou",
    "Dracoqueue", "SacdeNoeuds", "DSK", "Roucouille",
    "Bitachu"].sample
  end

  def create_enemies (fight_nb)
    @enemies = []
    enemy_power = fight_nb**2
    enemy_power.times do
      flip_coin = [true,false].sample
      if flip_coin #si true, ajoute un ennemi
        add_enemy
      else # si false, augmente le skill d'un ennemi
        upgrade_enemy
      end
    end
  end

  def add_enemy
    name = random_name
    used_names = @enemies.map {|e| e.name}
    while used_names.include?(name) && @enemies.length < used_names.length
      name = random_name
    end
    bot = Player.new(random_name)
    @enemies << bot
    puts_slow "Un #{bot.name} sauvage apparaît !!"
  end

  def upgrade_enemy
    unless @enemies.length == 0
      enemy = @enemies.sample
      enemy.skill += 1
      enemy.hp += 5
      puts_slow "#{enemy.name} a un plus gros skill que prévu : (#{enemy.skill} !!)"
    else
      add_enemy
    end
  end
end
