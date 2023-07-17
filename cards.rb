class Cards
  attr_reader :cards

  def initialize
    @cards = create_deck
  end

  def take_random_card
    cards.delete_at(rand(0..cards.size - 1))
  end

  def create_deck
    card_values = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, [1, 11]]
    card_names = %w[
      two three four five six seven eight nine ten jack lady king ace
    ]
    card_suits = %w[+ <3 ^ <>]
    cards = []
    card_suits.each do |suit|
      13.times do |index|
        cards.push ({ card: card_names[index],
                      suit: suit.to_s,
                      value: card_values[index] })
      end
    end
    cards
  end
end
