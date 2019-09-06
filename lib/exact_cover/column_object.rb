module ExactCover
  # a column header
  class ColumnObject < DataObject
    attr_accessor :size # size (number of 1 in the column)
    attr_reader :name # name

    def initialize(size, name)
      super(nil)

      @size = size
      @name = name
    end
  end
end
