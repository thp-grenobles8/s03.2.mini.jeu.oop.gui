require_relative "../lib/player.rb"
require_relative "../lib/game.rb"
require_relative "../lib/puts_slow.rb"

describe "Player class" do
  it "should instanciate player" do
    player = Player.new("Josiane")
  end

  player = Player.new("Josiane")

  it "should have 10 hp and skill 1 at init" do
    expect(player.hp).to eq(10)
    expect(player.skill).to eq(1)
  end

  player2 = Player.new("Marcel")

  it "should attack properly" do
    player.attacks(player2)
    expect(player2.hp).not_to eq(10)
  end
end
