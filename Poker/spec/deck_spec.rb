require 'rspec'
require 'deck'

RSpec.describe Deck do
  subject(:deck) { Deck.new }
  let(:all_cards) { Deck.make_deck }

  describe "::make_deck" do
    it "returns an array of all 52 cards" do
      expect(all_cards.count).to eq(52)
      expect(all_cards.first).to be_a(Card)
    end
  end

  describe "#initialize" do
    let(:small_deck) { Deck.new (Array.new(10) { |index| double("card#{index}") }) }

    it "initializes a new deck with 52 cards by default" do
      expect(deck.count).to eq(52)
    end

    it "initializes a custom deck" do
      expect(small_deck.count).to eq(10)
    end
  end

  describe "#deal" do
    it "deals the number of cards specified" do
      expect(deck.deal(4).length).to eq(4)
    end

    it "removes cards from the deck" do
      cards = deck.deal(4)
      expect(deck.count).to eq(48)
    end

    it "deals valid cards" do
      card = deck.deal(1).first
      expect(card.class).to eq(Card)
    end
  end
end
