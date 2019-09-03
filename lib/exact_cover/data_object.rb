module ExactCover
  # represents a "1" in the given matrix
  class DataObject
    attr_accessor :left, :right, :up, :down # left, right, up and down links
    attr_reader :column # link to column object

    # @param column [ColumnObject]
    def initialize(column)
      @column = column
      @left = nil
      @right = nil
      @up = nil
      @down = nil
    end
  end
end
