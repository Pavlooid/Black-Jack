require_relative 'cards'

class Player
  attr_reader :cards, :dollars

  def initialize
    @dollars = 100
    @cards = []
    @aces = 0
    @value = 0
  end

  def prepare_for_new_game
    @cards = []
    @aces = 0
    @value = 0
  end

  def make_bet
    @dollars -= 10 if @dollars > 0
  end

  def return_bet
    @dollars += 10
  end

  def bet_on_win(bank)
    @dollars += bank
  end

  def take_card(card)
    @cards << card
    if card[:card] == 'ace'
      @aces += 1
    else
      @value += card[:value]
    end
  end

  def overall_value
    if @aces.zero?
      @value
    else
      max_value = 0
      ace_value(@aces).each do |ace|
        result = @value + ace
        max_value = result if result <= 21
      end
      max_value
    end
  end

  private

  def ace_value(aces)
    case aces
    when 1
      [1, 11]
    when 2
      [2, 12]
    when 3
      [3, 13]
    end
  end
end
