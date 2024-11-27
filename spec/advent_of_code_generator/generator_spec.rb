# frozen_string_literal: true

RSpec.describe AdventOfCodeGenerator::Generator do
  subject(:instance) { described_class.new(2024, 1, "username") }

  after do
    FileUtils.rm_rf("username")
  end

  it "creates a README file" do
    instance.call

    expect(File.read("username/year_2024/day_01/README.md")).to eq("")
  end

  it "creates a data.txt file" do
    instance.call

    expect(File.read("username/year_2024/day_01/data.txt")).to eq("")
  end

  it "creates a main.rb file" do
    instance.call

    expect(File.read("username/year_2024/day_01/main.rb")).to eq(
      <<~RUBY
        # frozen_string_literal: true

        module Username
          module Year2024
            class Day01
              def initialize(input)
                @input = input
              end

              def part_one
                raise NotImplementedError
              end

              def part_two
                raise NotImplementedError
              end
            end
          end
        end
      RUBY
    )
  end

  it "creates a spec.rb file" do
    instance.call

    expect(File.read("username/year_2024/day_01/spec.rb")).to eq(
      <<~RUBY
        # frozen_string_literal: true

        require_relative "main"

        RSpec.describe Username::Year2024::Day01 do
          subject(:puzzle) { described_class.new(input) }

          let(:input) { File.read("\#{__dir__}/data.txt") }

          it "solves Part One" do
            expect(puzzle.part_one).to eq("")
          end

          xit "solves Part Two" do
            expect(puzzle.part_two).to eq("some other value")
          end
        end
      RUBY
    )
  end
end
