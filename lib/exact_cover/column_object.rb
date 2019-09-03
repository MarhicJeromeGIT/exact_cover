module ExactCover
  # a column header
  class ColumnObject < DataObject
    attr_reader :s # size (number of 1 in the column)
    attr_reader :name # name

    def initialize(s, name)
      super(nil)

      @s = s
      @name = name
    end
  end
end
