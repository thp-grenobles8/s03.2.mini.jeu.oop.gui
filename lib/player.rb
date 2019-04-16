class Player
  attr_accessor :name, :hp #pas life_point, c'est moche
  attr_reader :dead #bonus
  @@all = []

  def initialize (name)
    @name = name
    @hp = 10
    @dead = false
    @@all << self
  end

  def show_state
    puts "#{@name} a #{@hp} points de vie"
    puts ""
  end

  def gets_damage (damage)
    @hp = (@hp - damage) > 0 ? @hp - damage : 0 #pas de vie négative ...
    puts " => #{@name} a perdu #{damage} hp ! il lui en reste #{@hp}"
    if @hp == 0
      puts ""
      puts "#{@name} est mort !"
      @dead = true
    end
  end

  def attacks (player)
    puts "#{@name} attaque #{player.name} !!!"
    attack = compute_damage
    puts " => attaque #{attack[:name]}"
    if attack[:damage] < 3
      puts " => ça n'est pas très efficace..."
    else
      puts " => OUHAOU c'est très efficace !"
    end
    player.gets_damage(attack[:damage])
    puts "(appuie sur une touche pour continuer)"
    gets.chomp
    if player.dead
      puts "#{@name} a gagné !!"
    end
  end

  private #

  def get_attack
    #j'ai upgrade le compute_damge
    dice = rand(1..6)
    attack_name = {1=> "trempette", 2=> "mimiqueue", 3=> "jet de sable",
    4=> "pistolet à eau",5=> "psycho !",6=> "ULTRALAZER" }.select {
      |k, v|
      k == dice
    }.values[0] # pour savoir quelle attaque a été lancée
    return {:name => attack_name, :damage => dice}
  end

  def compute_damage
    get_attack #inutile pour les bots
  end

end

class HumanPlayer < Player
  attr_accessor :weapon_level

  def initialize (name)
    super(name)
    @hp = 100
    @weapon_level = 1
  end

  def show_state
    puts "#{@name} a #{@hp} points de vie
    et une arme de niveau #{@weapon_level}"
    puts ""
  end

  def search_weapon
    puts ""
    puts "#{@name} cherches une arme..."
    dice = rand(1..6)
    puts " => trouvé une arme de niveau #{dice}"
    if dice > @weapon_level
      @weapon_level = dice
      puts " => ça valait le coup ! #{@name} la garde"
    else
      puts " => ça ne vaut pas le coup, #{@name} garde son arme de niveau #{@weapon_level}"
    end
    puts "(appuie sur une touche pour continuer)"
    gets.chomp
    puts ""
  end

  def search_health_pack
    puts "#{@name} cherches une potion..."
    dice = rand(1..6)
    case dice
    when 1
      puts " => il n'a rien trouvé..."
    when 2..5
      puts " => trouvé une potion de 50 hp !"
      @hp + 50 > 100 ? @hp = 100 : @hp = @hp + 50
      puts " => #{@name} a maintenant #{@hp} points de vie"
    else
      puts " => trouvé une SUPER POTION de 50 hp !"
      @hp + 80 > 100 ? @hp = 100 : @hp = @hp + 80
      puts " => #{@name} a maintenant #{@hp} points de vie"
    end
    puts "(appuie sur une touche pour continuer)"
    gets.chomp
    puts ""
  end

  private

  def compute_damage
    attack = get_attack
    attack[:damage] *= @weapon_level #damage * level
    attack
  end

end
