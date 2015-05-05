class WordChainer
  def initialize(dictionary_file_name)
    @dictionary = File.readlines(dictionary_file_name).map { |line| line.chomp }
  end

  def adjacent_words(word)
    same_length = @dictionary.select {|entry| entry.length == word.length}

    adjacent_words = []

    word.length.times do |skip_index|
      substring1 = word[0...skip_index] + word[skip_index + 1..-1]
      same_length.each do |entry|
        substring2 = entry[0...skip_index] + entry[skip_index + 1..-1]

        adjacent_words << entry if substring1 == substring2
      end
    end

    adjacent_words.delete_if {|entry| entry == word }

    adjacent_words
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = { source => nil }

    until @current_words.empty?
      explore_current_words
    end

    path = build_path(target)

    p path
  end

  def explore_current_words
    new_current_words = []

    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adjacent_word|
        if !@all_seen_words.include?(adjacent_word)
          new_current_words << adjacent_word
          @all_seen_words[adjacent_word] = current_word
        end
      end
    end

    @current_words = new_current_words
  end

  def build_path(target)
    current_word = target
    path = []

    until current_word.nil?
      path = [current_word] + path

      current_word = @all_seen_words[current_word]

      if current_word == target
        @current_words = []
        break
      end
    end

    path
  end
end

if __FILE__ == $PROGRAM_NAME
  wc = WordChainer.new("dictionary.txt")

  wc.run("duck", "ruby")
end
