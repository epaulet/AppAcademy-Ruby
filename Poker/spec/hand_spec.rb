require 'rspec'
require 'spec_helper'
require 'hand'

RSpec.describe Hand do
  subject(:hand) { Hand.new }
  let(:deck) { double("deck") }
  let(:three_cards) { Array.new(3) { |index| double("card ##{index}") } }

  describe "#initialize" do
    it "initializes a new hand without cards by default" do
      expect(hand.count).to eq(0)
    end
  end

  describe "#draw" do
    it "draws the correct number of cards from the deck" do
      expect(deck).to receive(:deal).with(3).and_return(three_cards)

      hand.draw(deck, 3)
      expect(hand.count).to eq(3)
    end
  end

  describe "#discard" do
    let(:bad_card) { double("bad_card") }
    let(:bad_hand) { Hand.new([bad_card]) }
    let(:absent_card) { double("absent_card") }

    it "discards cards form the hand" do
      expect(bad_hand.discard(bad_card)).to be true
    end

    it "does not allow discarding a card not in hand" do
      expect do
        bad_hand.discard(absent_card)
      end.to raise_error("card not found")
    end

    it "cannot discard from an empty hand" do
      expect do
        hand.discard(:card)
      end.to raise_error("empty hand")
    end
  end

  describe "#compare" do
    let(:straight_flush) { [Card.new(:clubs, 11),
                            Card.new(:clubs, 10),
                            Card.new(:clubs, 9),
                            Card.new(:clubs, 8),
                            Card.new(:clubs, 7)] }
    let(:full_house)    { [Card.new(:hearts, 5),
                           Card.new(:spades, 5),
                           Card.new(:diamonds, 5),
                           Card.new(:spades, 8),
                           Card.new(:hearts, 8)] }
    let(:flush_hand)    { Hand.new(straight_flush) }
    let(:full_hand)     { Hand.new(full_house) }
    let(:pair_kings)    { Hand.new([Card.new(:clubs, 13),
                                    Card.new(:spades, 13),
                                    Card.new(:hearts, 9),
                                    Card.new(:clubs, 8),
                                    Card.new(:hearts, 11)]) }
    let(:pair_deuces)   { Hand.new([Card.new(:diamonds, 2),
                                    Card.new(:hearts, 2),
                                    Card.new(:hearts, 12),
                                    Card.new(:hearts, 7),
                                    Card.new(:clubs, 6)]) }
    let(:pair_kings2)   { Hand.new([Card.new(:hearts, 13),
                                    Card.new(:diamonds, 13),
                                    Card.new(:hearts, 6),
                                    Card.new(:clubs, 7),
                                    Card.new(:hearts, 4)]) }
    let(:singles1)      { Hand.new([Card.new(:hearts, 13),
                                    Card.new(:hearts, 12),
                                    Card.new(:hearts, 11),
                                    Card.new(:hearts, 10),
                                    Card.new(:diamonds, 6)])}
    let(:singles2)      { Hand.new([Card.new(:spades, 13),
                                    Card.new(:spades, 12),
                                    Card.new(:spades, 11),
                                    Card.new(:spades, 10),
                                    Card.new(:diamonds, 2)])}

    it "allows a straight flush to win against a full house" do
      expect(flush_hand.compare(full_hand)).to eq(1)
    end

    it "checks card values if ranking is a tie" do
      expect(pair_kings.compare(pair_deuces)).to eq(1)
    end

    it "checks other cards if highest ranking is a tie" do
      expect(pair_kings.compare(pair_kings2)).to eq(1)
    end

    it "compares singles correctly" do
      expect(singles1.compare(singles2)).to eq(1)
    end

    it "calls a tie when two players have same hand rankings" do
      expect(flush_hand.compare(flush_hand)).to eq(0)
    end
  end

end
