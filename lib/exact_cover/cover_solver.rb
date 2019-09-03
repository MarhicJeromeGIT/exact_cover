# Cover problem solver
# Ruby implementation of https://arxiv.org/abs/cs/0011047 (Dancing Link algorithm)
# Can be used to solve tetramino or sudoku problems
# @author Marhic Jerome 2019

module ExactCover
  # Solves the cover problem with algorithm "X"
  class CoverSolver
    class InvalidMatrixSize < StandardError; end

    attr_reader :matrix
    attr_reader :column_count

    def initialize(matrix)
      @matrix = matrix
      # sanity check
      if !matrix.is_a?(Array) || matrix.size == 0 || matrix[0].size == 0
        raise(InvalidMatrixSize, "non-empty 2-dimensional array expected, got #{matrix.inspect}")
      end

      @column_count = matrix[0].size
    end

    # Solve the exact cover problem for the given matrix
    # @return [Enumerator] An enumeration of the all the possible solutions
    def call
      root = MatrixPreprocessor.new(matrix).call
      Enumerator.new do |y|
        search(0, root, y)
      end
    end

    private

    # @param k [Integer] solution "deepness"
    # @param root [ColumnObject] root
    # @param y [Yielder] enumerator yielder
    # @param solution [Array<DataObject>] current solution
    def search(k, root, y, solution = [])
      if root.right == root
        y.yield format_solution(solution)
        return
      end

      column = choose_column(root)
      cover_column(column)

      r = column.down
      loop do
        break if r == column

        solution[k] = r

        j = r.right
        loop do
          break if j == r

          cover_column(j.column)
          j = j.right
        end

        search(k + 1, root, y, solution)

        r = solution[k]
        column = r.column

        j = r.left
        loop do
          break if j == r

          uncover_column(j.column)

          j = j.left
        end

        r = r.down
      end

      uncover_column(column)
    end

    # @solution consists in an array of DataObject,
    # formats it to an array of 0 and 1 rows (corresponding to some rows of the given matrix)
    # @return [Array<Array>] Subset of the matrix rows corresponding to an exact cover
    def format_solution(solution)
      rows = []
      solution.each do |data_object|
        row = Array.new(column_count, 0)
        current = data_object
        loop do
          row[current.column.name.to_i] = 1
          current = current.right
          break if current == data_object
        end
        rows << row
      end
      rows
    end

    def choose_column(root)
      root.right
    end

    # removes c from the header list
    # @param column [ColumnObject]
    def cover_column(column)
      column.right.left = column.left
      column.left.right = column.right

      i = column.down
      loop do
        break if i == column

        j = i.right
        loop do
          break if j == i

          j.down.up = j.up
          j.up.down = j.down

          j = j.right
        end

        i = i.down
      end
    end

    def uncover_column(column)
      i = column.up
      loop do
        break if i == column

        j = i.left
        loop do
          break if j == i

          j.down.up = j
          j.up.down = j

          j = j.left
        end

        i = i.up
      end

      column.left.right = column
      column.right.left = column
    end
  end
end
