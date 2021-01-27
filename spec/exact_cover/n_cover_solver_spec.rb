require "byebug"
require "nmatrix"

RSpec.describe ExactCover::NCoverSolver do
  subject { described_class.new(matrix) }

  describe "#call" do
    context "empty matrix" do
      let(:matrix) do
        NMatrix.new(
          [0],
        )
      end

      it "raises an error" do
        expect { subject.call }.to raise_error(ExactCover::CoverSolver::InvalidMatrixSize)
      end
    end

    context "when there is a solution" do
      context "simple matrix" do
        let(:matrix) do
          [
            [0, 1],
            [1, 0]
          ]
        end

        it "finds the solution" do
          solutions = subject.call
          expect(solutions.count).to eq 1
          expect(solutions.first).to eq(
            [
              [1, 0],
              [0, 1]
            ]
          )
        end
      end

      context "complex matrix" do
        let(:matrix) do
          [
            [0, 0, 1, 0, 1, 1, 0],
            [1, 0, 0, 1, 0, 0, 1],
            [0, 1, 1, 0, 0, 1, 0],
            [1, 0, 0, 1, 0, 0, 0],
            [0, 1, 0, 0, 0, 0, 1],
            [0, 0, 0, 1, 1, 0, 1]
          ]
        end

        it "finds the only solution" do
          solutions = subject.call
          expect(solutions.count).to eq 1
          expect(solutions.first).to eq(
            [
              [1, 0, 0, 1, 0, 0, 0],
              [0, 0, 1, 0, 1, 1, 0],
              [0, 1, 0, 0, 0, 0, 1]
            ]
          )
        end
      end
    end

    context "when there are several solutions" do
      let(:matrix) do
        [
          [1, 1],
          [0, 1],
          [1, 0]
        ]
      end

      it "enumerates all the solutions" do
        solutions = subject.call
        expect(solutions.to_a).to eq(
          [
            [[1, 1]],
            [[1, 0], [0, 1]]
          ]
        )
      end

      context "when the rows are reversed" do
        let(:matrix) do
          [
            [0, 1],
            [1, 0],
            [1, 1]
          ]
        end

        it "enumerates all the solutions" do
          solutions = subject.call
          expect(solutions.to_a).to eq(
            [
              [[1, 0], [0, 1]],
              [[1, 1]],
            ]
          )
        end
      end
    end

    context "when there is no solution" do
      context "simple matrix" do
        let(:matrix) do
          [
            [0, 0],
            [1, 0]
          ]
        end

        it "doesn't find any solution" do
          solutions = subject.call
          expect(solutions.count).to eq 0
          expect(solutions.first).to be nil
        end
      end
    end

    context "identity matrix" do
      let(:matrix) do
        matrix = []
        (0..19).each do |row|
          matrix[row] = Array.new(20, 0)
          matrix[row][row] = 1
        end
        matrix
      end

      it "returns all the row" do
        solutions = subject.call
        expect(solutions.first).to eq matrix
      end

      context "when the matrix is shuffled" do
        before do
          matrix.shuffle!
        end

        it "returns all the row" do
          solutions = subject.call
          expect(solutions.first.sort).to eq matrix.sort
        end
      end
    end
  end
end
