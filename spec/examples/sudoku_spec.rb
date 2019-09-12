require "byebug"

# sudoku = [
#   [0, 4, 5, 6, 3, 2, 1, 7, 9],
#   [7, 3, 2, 9, 1, 8, 6, 5, 4],
#   [1, 9, 6, 7, 4, 5, 3, 2, 8],
#   [6, 8, 3, 5, 7, 4, 9, 1, 2],
#   [4, 5, 7, 2, 9, 1, 8, 3, 6],
#   [2, 1, 9, 8, 6, 3, 5, 4, 7],
#   [3, 6, 1, 4, 2, 9, 7, 8, 5],
#   [5, 7, 4, 1, 8, 6, 2, 9, 3],
#   [9, 2, 8, 3, 5, 7, 4, 6, 1]
# ].freeze

# sudoku = [
#   [0, 0, 2, 0, 0, 0, 5, 0, 0],
#   [0, 1, 0, 7, 0, 5, 0, 2, 0],
#   [4, 0, 0, 0, 9, 0, 0, 0, 7],
#   [0, 4, 9, 0, 0, 0, 7, 3, 0],
#   [8, 0, 1, 0, 3, 0, 4, 0, 9],
#   [0, 3, 6, 0, 0, 0, 2, 1, 0],
#   [2, 0, 0, 0, 8, 0, 0, 0, 4],
#   [0, 8, 0, 9, 0, 2, 0, 6, 0],
#   [0, 0, 7, 0, 0, 0, 8, 0, 0]
# ].freeze

sudoku = [
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0]
].freeze

row_count = sudoku.size
col_count = sudoku[0].size

def build_zeroes_array(size, one_index)
  (0..size - 1).map do |i| i == one_index ? 1 : 0 end
end

# build the cover problem
# for each unknown value:
# col 0-9 col_index_row (0 for the unknown values) - represents the fact we want to use every known values
# col 10-9 digit value - represent the fact we want to use every number between 1 and 9
# col 9-17 row index - represents a different number for each row
matrix = []
(0..row_count - 1).each do |row|
  (0..col_count - 1).each do |col|
    matrix_rows = []
    val = sudoku[row][col]

    square_index = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
    ][row / 3][col / 3]

    if val == 0
      (1..9).each do |possible_value|
        matrix_row = []
        matrix_row += build_zeroes_array(81, row * 9 + col)

        matrix_row += build_zeroes_array(81, row * 9 + possible_value - 1) # the val is in the rowth row
        matrix_row += build_zeroes_array(81, col * 9 + possible_value - 1) # the val is in the colth col
        matrix_row += build_zeroes_array(81, square_index * 9 + possible_value - 1) # the val is in the 3*3 square square_index
        matrix_rows << matrix_row
      end
    else
      matrix_row = []
      matrix_row += build_zeroes_array(81, row * 9 + col)

      matrix_row += build_zeroes_array(81, row * 9 + val - 1) # the val is in the rowth row
      matrix_row += build_zeroes_array(81, col * 9 + val - 1) # the val is in the colth col

      matrix_row += build_zeroes_array(81, square_index * 9 + val - 1) # the val is in the 3*3 square square_index
      matrix_rows << matrix_row
    end

    matrix += matrix_rows
  end
end

def format_solution(solution)
  # for a given matrix row, find the value, row and col
  sol = {}

  solution.each do |matrix_row|
    idx = matrix_row[0..80].index(1)
    row = idx / 9
    col = idx % 9
    val = 1 + matrix_row[81..81+80].index(1) % 9

    # debugger if row == nil || val == nil || col == nil
    # puts "#{val} at (#{row}, #{col})"

    # debugger if sol[[row, col]] != nil
    sol[[row, col]] = val
  end

  puts "________"

  (0..8).each do |row|
    sol_row = ""
    (0..8).each do |col|
      sol_row << sol[[row, col]].to_s
      sol_row << " "
    end
    puts sol_row
  end
end

solutions = ExactCover::CoverSolver.new(matrix).call
#puts solutions.count
puts "____"
10.times do
  format_solution(solutions.next)
end
