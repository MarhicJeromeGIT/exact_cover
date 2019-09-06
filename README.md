# ExactCover

This gem is a ruby implementation of D.Knuth's paper "Dancing Link" : https://arxiv.org/abs/cs/0011047
It implements a solver for the "exact cover of a matrix" problem. For a given matrix of 0s and 1s, it finds a set of
rows that contains exactly one "1" in each column.
This can be used to implement a tetramino or a sudoku solver.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exact_cover'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exact_cover

## Usage

Basic usage
```
require "exact_cover"

matrix =
  [
    [0, 0, 1, 0, 1, 1, 0],
    [1, 0, 0, 1, 0, 0, 1],
    [0, 1, 1, 0, 0, 1, 0],
    [1, 0, 0, 1, 0, 0, 0],
    [0, 1, 0, 0, 0, 0, 1],
    [0, 0, 0, 1, 1, 0, 1]
  ]

solutions = ExactCover::CoverSolver.new(matrix).call
solutions.count
# => 1
solutions.first
# => [[1, 0, 0, 1, 0, 0, 0], [0, 1, 0, 0, 0, 0, 1], [0, 0, 1, 0, 1, 1, 0]]
# this corresponds to the 4th, 3rd and first rows of the given matrix
```

You can iterate through all the solutions
```
require "exact_cover"

matrix =
  [
    [1, 1],
    [0, 1],
    [1, 0]
  ]

solutions = ExactCover::CoverSolver.new(matrix).call
solutions.count
# => 2
solutions.next
# => [[1, 1]]
solutions.next
# => [[1, 0], [0, 1]]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/exact_cover.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
