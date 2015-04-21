class Hangman
  def initialize(guesser, checker)
    @guesser = guesser
    @checker = checker
  end

  def play
    @board = @checker.pick_secret_word
    @chances_left = @board.length + 5

    until !@board.include?("_") || @chances_left == 0
      puts "Chances left: #{@chances_left}"

      guess = @guesser.guess(@board)
      new_board = @checker.check_guess(guess, @board)

      @chances_left -= 1 if new_board == @board

      @board = new_board
    end

    if @chances_left > 0
      puts "WINNER!"
    else
      puts "LOSER!"
    end
  end
end


class HumanPlayer
  def pick_secret_word
    puts "Please pick a secret word. \n"
    print "Please enter secret word length: "

    length = gets.chomp.to_i

    new_board = "_" * length
  end

  def guess(board)
    puts "Current Board: #{board}"
    print "Please enter letter or full word: "

    gets.chomp
  end

  def check_guess(new_guess, board)
    puts "Current Board: #{board}"

    new_board = board

    if new_guess.length > 1
      puts "Is the word #{new_guess}? (y/n)"

      input = gets.chomp

      new_board = new_guess if input == "y"
    else
      guess_locations = find_locs(new_guess)

      new_board = board.dup

      guess_locations.each { |loc| new_board[loc] = new_guess }
    end

    new_board
  end

  def find_locs(new_guess)
    puts "Does the word contain #{new_guess}? (y/n)"

    response = gets.chomp

    guess_locations = []

    if response == "y"
      puts "Enter positions individually. Then enter 'done'."
      input = ""

      until input == "done"
        print "> "
        input = gets.chomp

        unless input == "done"
          guess_locations << input.to_i
        end
      end
    end

    guess_locations
  end
end


class ComputerPlayer
  def initialize(filename)
    @dictionary = File.readlines(filename).map {|line| line.chomp}
    @already_guessed = []
  end

  def pick_secret_word
    @secret_word = @dictionary.sample

    "_" * @secret_word.length
  end

  def guess(board)
    possible_words = filter_words(board)

    new_guess = highest_freq(possible_words)

    @already_guessed << new_guess

    new_guess
  end

  def check_guess(guess, board)
    if guess.length == 1
      new_board = board.dup

      @secret_word.chars.each_with_index do |character, index|
        new_board[index] = guess if character == guess
      end

      new_board
    else
      @secret_word == guess ? guess : board
    end
  end

  private

  def filter_words(board)
    possible_words = @dictionary.dup

    possible_words = possible_words.select do |word|
      word.length == board.length
    end

    board.chars.each_with_index do |character, index|
      unless character == "_"
        possible_words = possible_words.select do |word|
          word[index] == character
        end
      end
    end

    possible_words
  end

  def highest_freq(words)
    freqs = Hash.new { |h, k| h[k] = 0 }

    words.each do |word|
      word.chars.each do |letter|
        freqs[letter] += 1
      end
    end

    freqs = freqs.delete_if do |letter, frequency|
      @already_guessed.include?(letter)
    end

    most_freq = ""

    freqs.each do |letter, frequency|
      most_freq = letter if most_freq == "" || frequency > freqs[most_freq]
    end

    most_freq
  end
end

if __FILE__ == $PROGRAM_NAME
  comp = ComputerPlayer.new("dict.txt")
  hum = HumanPlayer.new

  # game = Hangman.new(hum, comp)
  # game.play

  # game2 = Hangman.new(comp, hum)
  # game2.play

  comp2 = ComputerPlayer.new("dict.txt")

  # game3 = Hangman.new(comp, comp2)
  # game3.play

  hum2 = HumanPlayer.new
  game4 = Hangman.new(hum, hum2)
  game4.play
end
