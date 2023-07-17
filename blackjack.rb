require_relative 'player'
require_relative 'cards'

class BlackJack
  attr_reader :deck, :gamer, :dealer, :bank

  def initialize
    puts 'Welcome to game BlackJack, please write your name: '
    @name = gets.chomp.to_s.capitalize
    @deck = Cards.new
    @gamer = Player.new
    @dealer = Player.new
    take_two_cards
    bets_on_start
  end

  def commands
    puts "Available commands:
    1 - skip round
    2 - add card
    3 - open cards"
    print 'Enter command: '
  end

  def gamer_command(number)
    case number
    when 1
      skip
    when 2
      add_card
    when 3
      open_cards
    end
  end

  def gamer_turn
    show_score
    commands
    command = gets.chomp.to_i
    gamer_command(command)
  end

  def dealer_turn
    take_one_card(dealer) if dealer_score < 17 && dealer.cards.size < 3
    gamer_turn
  end

  def skip
    return finish_game if game_over?
    if dealer_score >= 17
      puts 'Dealer skipped turn too, you must add card or open cards!'
    else
      puts 'Dealer has taken card!'
    end
    dealer_turn
  end

  def add_card
    return finish_game if game_over?
    take_one_card(gamer)
    puts "You've taken card: #{gamer.cards.last.inspect}"
    dealer_turn
  end

  def open_cards
    puts 'Opening cards...'
    finish_game
  end

  def finish_game
    puts 'Game over, getting results...'
    sleep 3
    final_results
    print "Results: #{show_winner(winner)}"
    banking(winner)
    puts "#{@name} bank: #{gamer.dollars}
    dealer bank : #{dealer.dollars}"
    new_game
  end

  def banking(player)
    case player
    when 'gamer'
      gamer.bet_on_win(@bank)
    when 'dealer'
      dealer.bet_on_win(@bank)
    when 'draw'
      gamer.return_bet
      dealer.return_bet
    end
    @bank = 0
  end

  def winner
    return 'gamer' if gamer_score <= 21 && dealer_score > 21
    return 'draw' if gamer_score == dealer_score
    return 'dealer' if dealer_score <= 21 && gamer_score > 21
    if gamer_score > dealer_score
      return 'gamer'
    else
      return 'dealer'
    end
  end

  def show_winner(player)
    case player
    when 'gamer'
      puts 'Gamer win!'
    when 'dealer'
      puts 'Dealer win!'
    when 'draw'
      puts 'Draw!'
    end
  end

  def new_game
    puts "Do you want to play again?
    1 - yes
    2 - no "
    print 'Enter command: '
    number = gets.chomp.to_i
    new_game_command(number)
  end

  def new_game_command(number)
    case number
    when 1
      start_new_game
    when 2
      puts "Thank's for playing, closing program..."
      sleep 5
      exit
    end
  end

  def start_new_game
    if gamer.dollars <= 0
      puts "You don't have enough money!"
      sleep 5
      exit
    else
      create_new_game
    end
  end

  def create_new_game
    @deck = Cards.new
    gamer.prepare_for_new_game
    dealer.prepare_for_new_game
    take_two_cards
    bets_on_start
    gamer_turn
  end

  def show_score
    puts "#{@name} cards: #{view_cards(gamer)},
    overall value: #{gamer_score},
    Dealer cards: #{dealer_hidden_cards}."
  end

  def view_cards(user)
    user.cards.each(&:inspect)
  end

  def game_over?
    @gamer.cards.size == 3
  end

  def dealer_hidden_cards
    hidden_cards = []
    dealer.cards.size.times do
      hidden_cards << '*'
    end
    hidden_cards
  end

  def dealer_score
    dealer.overall_value
  end

  def gamer_score
    gamer.overall_value
  end

  def final_results
    puts "#{@name} cards: #{view_cards(gamer)},
    overall value: #{gamer_score},
    dealer cards: #{view_cards(dealer)},
    overall value: #{dealer_score}."
  end

  def take_one_card(user)
    user.take_card(deck.take_random_card)
  end

  def bets_on_start
    @gamer.make_bet
    @dealer.make_bet
    @bank = 20
  end

  def take_two_cards
    2.times do
      @gamer.take_card(deck.take_random_card)
      @dealer.take_card(deck.take_random_card)
    end
  end
end

game = BlackJack.new
game.gamer_turn
