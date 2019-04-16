class Player
  attr_accessor :name, :hp, :skill #pas life_point, c'est moche
  attr_reader :dead #bonus
  @@all = []

  def initialize (name, skill = 1)
    @name = name
    @dead = false
    @skill = skill
    @hp = 10
    @@all << self
  end

  def show_state
    puts_slow "#{@name} :"
    puts_slow "|"*(70*@hp/100).to_i+"#hp #{@hp}"
    puts_slow "|"*(@skill+1)*3+"#skill #{@skill}"
    if self.kind_of? HumanPlayer
      puts_slow "|"*(@weapon_level)*(50/6)+"#weapon #{@weapon_level}"
    end
    puts_slow ""
  end

  def gets_damage (damage)
    @hp = (@hp - damage) > 0 ? @hp - damage : 0 #pas de vie négative ...
    puts_slow " => #{@name} a perdu #{damage} hp ! il lui en reste #{@hp}"
    if @hp == 0
      puts_slow ""
      puts_slow "#{@name} est mort !"
      @dead = true
    end
  end

  def attacks (player)
    puts_slow "#{@name} attaque #{player.name} !!!"
    attack = compute_damage
    puts_slow " => attaque #{attack[:name]}"
    if attack[:damage] < 3
      puts_slow " => ça n'est pas très efficace..."
    else
      puts_slow " => OUHAOU c'est très efficace !"
    end
    player.gets_damage(attack[:damage])
    if player.dead
      puts_slow "#{@name} a tué #{player.name} !!"
      if self.kind_of? HumanPlayer
        skill = (rand(1..10)*0.1).round(2)
        @skill += skill
        puts_slow "et a gagné #{skill} points de skill"
      end
    end
    puts_slow "(appuie sur une touche pour continuer)"
    gets.chomp
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
    attack = get_attack
    attack[:damage] = (attack[:damage] * @skill).round(2)
    attack
  end

end

class HumanPlayer < Player
  attr_accessor :weapon_level

  def initialize (name, skill = 1)
    super(name, skill)
    @hp = 100
    @weapon_level = 1
  end

  # def show_state
  #   puts_slow "#{@name} a #{@hp} points de vie
  #   et une arme de niveau #{@weapon_level}"
  #   puts_slow ""
  # end

  def search_weapon
    puts_slow ""
    puts_slow "#{@name} cherches une arme..."
    dice = rand(1..6)
    puts_slow " => trouvé une arme de niveau #{dice}"
    if dice > @weapon_level
      @weapon_level = dice
      puts_slow " => ça valait le coup ! #{@name} la garde"
    else
      puts_slow " => ça ne vaut pas le coup, #{@name} garde son arme de niveau #{@weapon_level}"
    end
    puts_slow "(appuie sur une touche pour continuer)"
    gets.chomp
    puts_slow ""
  end

  def search_health_pack
    puts_slow "#{@name} cherches une potion..."
    dice = rand(1..6)
    case dice
    when 1
      puts_slow " => il n'a rien trouvé..."
    when 2..5
      puts_slow " => trouvé une potion de 50 hp !"
      @hp + 50 > 100 ? @hp = 100 : @hp = @hp + 50
      puts_slow " => #{@name} a maintenant #{@hp} points de vie"
    else
      puts_slow " => trouvé une SUPER POTION de 80 hp !"
      @hp + 80 > 100 ? @hp = 100 : @hp = @hp + 80
      puts_slow " => #{@name} a maintenant #{@hp} points de vie"
    end
    puts_slow "(appuie sur une touche pour continuer)"
    gets.chomp
    puts_slow ""
  end

  private

  def compute_damage
    attack = get_attack
    attack[:damage] *= @weapon_level * @skill
    attack
  end

end
