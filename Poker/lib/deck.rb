require_relative 'card'

class Deck
  def self.make_deck
    cards = []
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value|
        cards << Card.new(suit, value)
      end
    end

    cards.shuffle
  end


  def initialize(cards = Deck.make_deck)
    @cards = cards
  end

  def deal(n)
    [].tap do |dealt_cards|
      n.times { dealt_cards << @cards.pop }
    end
  end

  def count
    @cards.count
  end
end
