require 'rspec'
require 'card'

RSpec.describe Card do
  describe "#initialize" do
    let(:card) { Card.new(:hearts, 3) }

    it "initializes a card properly given the suit and value" do
      expect(card.suit).to eq(:hearts)
      expect(card.value).to eq(3)
    end
  end

  describe "==" do
    let(:card1) { Card.new(:hearts, 3) }
    let(:card2) { Card.new(:hearts, 3) }
    let(:diff_suit) { Card.new(:spades, 3) }
    let(:diff_val) { Card.new(:hearts, 5) }

    it "considers cards with same suit/value equal" do
      expect(card1).to eq(card2)
    end

    it "considers cards with same value/value as different objects" do
      expect(card1).to_not be(card2)
    end

    it "considers cards different cards unequal" do
      expect(card1).to_not eq(diff_suit)
      expect(card1).to_not eq(diff_val)
    end
  end
end
