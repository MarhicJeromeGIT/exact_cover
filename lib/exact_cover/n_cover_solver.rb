# Cover problem solver
# Ruby implementation of https://arxiv.org/abs/cs/0011047 (Dancing Link algorithm)
# Can be used to solve tetramino or sudoku problems
# @author Marhic Jerome 2019

module ExactCover
  # Solves the cover problem with algorithm "X"
  class NCoverSolver
    class InvalidMatrixSize < StandardError; end
    class TimeLimitReached < StandardError; end

    attr_reader :matrix
    attr_reader :column_count
    attr_reader :time_limit
    attr_reader :start_time

    def initialize(matrix, time_limit: nil)
      @matrix = matrix
      # sanity check
      if !matrix.is_a?(Array) || matrix.size == 0 || matrix[0].size == 0
        raise(InvalidMatrixSize, "non-empty 2-dimensional array expected, got #{matrix.inspect}")
      end

      @column_count = matrix[0].size
      @time_limit = time_limit
    end

    # Solve the exact cover problem for the given matrix
    # @return [Enumerator] An enumeration of the all the possible solutions
    def call
      root = MatrixPreprocessor.new(matrix).call
      Enumerator.new do |y|
        @start_time = Time.now
        search(0, root, y)
      end
    end

    private

    # @param k [Integer] solution "deepness"
    # @param root [ColumnObject] root
    # @param y [Yielder] enumerator yielder
    # @param solution [Array<DataObject>] current solution
    def search(k, root, y, solution = [])
      if time_limit && start_time + time_limit < Time.now
        raise TimeLimitReached, "Ran for more than #{time_limit} seconds"
      end

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

        search(k + 1, root, y, solution.dup)

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
      # Minimize the branching factor by choosing the column with the lowest size
      min_size = root.right.size
      min_size_column = root.right

      current_column = min_size_column.right
      loop do
        break if current_column == root

        if current_column.size < min_size
          min_size = current_column.size
          min_size_column = current_column
        end

        current_column = current_column.right
      end

      min_size_column
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
          j.column.size -= 1

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

          j.column.size += 1
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
