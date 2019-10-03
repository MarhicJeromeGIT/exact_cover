require "exact_cover"
require "byebug"

ALPHABET = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z .].freeze
DICTIONARY = File.read("wordlist.txt").split("\n").map(&:strip).map(&:downcase)
WORDS = (ALPHABET + DICTIONARY).uniq

W = 6 # cols
H = 5 # rows
def build_zeroes_array(size, one_index)
  (0..size - 1).map do |i| i == one_index ? 1 : 0 end
end

def build_ones_array(size, zero_index)
  (0..size - 1).map do |i| i == zero_index ? 0 : 1 end
end

Word = Struct.new(:word, :row, :col, :horizontal)

class CrosswordGenerator
  attr_reader :solutions
  attr_reader :matrix
  attr_reader :matrix_row_to_word

  attr_reader :constraints

  def initialize(constraints = [])
    @constraints = constraints
    @matrix = []
    @matrix_row_to_word = {}

    WORDS.each do |word|
      puts "adding #{word}"
      word_index = WORDS.index(word)

      # represent the word in the row
      (0..H-1).each do |row|
        (0..W-1).each do |col|
          if word.size + col <= W
            matrix_row = add_horizontal_word(word, row, col, word_index)
            @matrix_row_to_word[matrix_row] = Word.new(word, row, col, true)
            @matrix << matrix_row
          end

          if word.size + row <= H
            matrix_row = add_vertical_word(word, row, col, word_index)
            @matrix_row_to_word[matrix_row] = Word.new(word, row, col, false)
            @matrix << matrix_row
          end
        end
      end
    end

    add_constraints
  end

  def solutions(time_limit: nil)
    ExactCover::CoverSolver.new(@matrix.shuffle, time_limit: 3).call
  end

  def format(solution)
    grid = format_solution(solution)
    print_grid(grid)
  end

  private

  def add_constraints
    puts "Starting with #{@matrix.size} rows"

    (0..H-1).each do |row|
      (0..W-1).each do |col|
        letter = constraints[row][col]
        index = (row * W + col) * ALPHABET.size

        if letter == "?" # we don't want a black cell here
          matrix_row_horizontal = build_zeroes_array(ALPHABET.size, ALPHABET.index("."))
          matrix_row_vertical = build_ones_array(ALPHABET.size, ALPHABET.index("."))

          @matrix = @matrix.select do |matrix_row|
            keep = true
            keep = false if matrix_row[index...index+ALPHABET.size] == matrix_row_horizontal
            keep = false if matrix_row[index...index+ALPHABET.size] == matrix_row_vertical
            keep
          end
        else # for this cell to be the given letter
          next if letter == " "

          zeroes = build_zeroes_array(ALPHABET.size, -1)
          matrix_row_horizontal = build_zeroes_array(ALPHABET.size, ALPHABET.index(letter))
          matrix_row_vertical = build_ones_array(ALPHABET.size, ALPHABET.index(letter))
          # Remove all matrix entries that don't match either one of those !
          @matrix = @matrix.select do |matrix_row|
            keep = false
            keep ||= true if matrix_row[index...index+ALPHABET.size] == zeroes
            keep ||= true if matrix_row[index...index+ALPHABET.size] == matrix_row_horizontal
            keep ||= true if matrix_row[index...index+ALPHABET.size] == matrix_row_vertical
            keep
          end
        end
      end
    end

    # (0..H-1).each do |row|
    #   (0..W-1).each do |col|
    #     next if constraints.include? [row, col]
    #
    #     letter = "."
    #     index = (row * W + col) * ALPHABET.size
    #
    #     # remove matrix rows that have a black square in this cell
    #     matrix_row_horizontal = build_zeroes_array(ALPHABET.size, ALPHABET.index(letter))
    #     matrix_row_vertical = build_ones_array(ALPHABET.size, ALPHABET.index(letter))
    #
    #     @matrix = @matrix.select do |matrix_row|
    #       keep = true
    #       keep = false if matrix_row[index...index+ALPHABET.size] == matrix_row_horizontal
    #       keep = false if matrix_row[index...index+ALPHABET.size] == matrix_row_vertical
    #       keep
    #     end
    #   end
    # end

    puts "Reste #{@matrix.size} rows"
  end

  def print_grid(grid)
    solution_str = ""
    (0..H-1).each do |row|
      row_str = ""
      (0..W-1).each do |col|
        row_str << grid[row][col] + " "
      end
      solution_str << row_str + "\n"
    end
    solution_str
  end

  def format_solution(solution)
    grid = Array.new(H)
    (0..H-1).each do |row|
      grid[row] = Array.new(W, ".")
    end

    solution.each do |matrix_row|
      word = @matrix_row_to_word[matrix_row]
      # puts "word: #{word}"
      next unless word

      word.word.split("").each_with_index do |letter, idx|
        next if letter == "."

        if word.horizontal
          col_index = word.col + idx
          grid[word.row][col_index] = letter
        else
          row_index = word.row + idx
          grid[row_index][word.col] = letter
        end
      end
    end

    grid
  end

  def add_horizontal_word(word, row, col, word_index, real: true)
    # puts "Adding #{word} to #{row}, #{col}"
    matrix_row = Array.new(2 * W * H * ALPHABET.size, 0)

    offset = W * H * ALPHABET.size
    offset_words = 2 * W * H * ALPHABET.size

    word.split("").each_with_index do |letter, idx|
      break if col + idx >= W

      index = (row * W + col + idx) * ALPHABET.size

      # horizontal part
      matrix_row[index + ALPHABET.index(letter)] = 1

      # vertical part
      ALPHABET.each do |alphabet_letter|
        if alphabet_letter != letter
          matrix_row[offset + index + ALPHABET.index(alphabet_letter)] = 1
        end
      end

    #  add_vertical_word(letter, row, col + idx, word_index, real: false) if real
    end

    if word != "." && col + word.size < W
      # add a X at the end of the word
      index = (row * W + col + word.size) * ALPHABET.size

      # horizontal part
      matrix_row[index + ALPHABET.index(".")] = 1

      # vertical part
      ALPHABET.each do |alphabet_letter|
        if alphabet_letter != "."
          matrix_row[offset + index + ALPHABET.index(alphabet_letter)] = 1
        end
      end
    end

    matrix_row
  end

  def add_vertical_word(word, row, col, word_index, real: true)
    # puts "Adding #{word} to #{row}, #{col}"

    matrix_row = Array.new(2 * W * H * ALPHABET.size, 0)

    offset = W * H * ALPHABET.size
    offset_words = 2 * W * H * ALPHABET.size

    word.split("").each_with_index do |letter, idx|
      break if row + idx >= H

      index = ((row + idx) * W + col) * ALPHABET.size

      # horizontal part
      ALPHABET.each do |alphabet_letter|
        if alphabet_letter != letter
          matrix_row[index + ALPHABET.index(alphabet_letter)] = 1
        end
      end

      # vertical part
      matrix_row[offset + index + ALPHABET.index(letter)] = 1

      # add_horizontal_word(letter, row + idx, col, word_index, real: false) if real
    end

    if word != "." && row + word.size < H
      # add a X at the end of the word
      index = ((row + word.size) * W + col) * ALPHABET.size

      # vertical part
      matrix_row[offset + index + ALPHABET.index(".")] = 1

      # horizontal part
      ALPHABET.each do |alphabet_letter|
        if alphabet_letter != "."
          matrix_row[index + ALPHABET.index(alphabet_letter)] = 1
        end
      end
    end

    matrix_row
  end
end
#
# num_black_square = (0.99 * W * H).round
# black_squares_positions =
#   num_black_square.times.map do
#     [rand(H), rand(W)]
#   end
#
# black_squares_positions = []
# (0..W-1).each do |j|
#   (0..H-1).each do |i|
#     black_squares_positions << [i, j] unless rand(100) > 10
#   end
# end

#

constraints = [
  "    n ",
  "hacker",
  "    w ",
  "    s ",
  "      ",
].map { |s| s.split("")  }

generator = CrosswordGenerator.new(constraints)
solutions = generator.solutions
solutions.each do |solution|
  grid = generator.format solution
  puts grid
  puts "__"
end

puts "fini"
