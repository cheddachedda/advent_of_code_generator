# frozen_string_literal: true

RSpec.describe AdventOfCodeGenerator::Generator do
  subject(:instance) { described_class.new({ year: 2024, day: 1, username: "username" }, scraped_data) }

  let(:scraped_data) do
    {
      puzzle_description: "<article>Test puzzle description</article>\n",
      input_data: "1234\n5678\n",
      test_input: %W[1\n2\n3\n4 5\n6\n7\n8],
      test_expectations: [123, 456]
    }
  end

  after do
    FileUtils.rm_rf("username")
  end

  it "creates a README file" do
    instance.call

    expect(File.read("username/year_2024/day_01/README.md")).to eq(
      <<~MARKDOWN
        <article>Test puzzle description</article>
      MARKDOWN
    )
  end

  it "creates a data.txt file" do
    instance.call

    expect(File.read("username/year_2024/day_01/data.txt")).to eq(
      <<~TEXT
        1234
        5678
      TEXT
    )
  end

  it "creates a main.rb file" do
    instance.call

    expect(File.read("username/year_2024/day_01/day_01.rb")).to eq(
      <<~RUBY
        # frozen_string_literal: true

        module Username
          module Year2024
            class Day01
              def self.part_one(input)
                raise NotImplementedError
              end

              def self.part_two(input)
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

    expect(File.read("username/year_2024/day_01/day_01_spec.rb")).to eq(
      <<~RUBY
        # frozen_string_literal: true

        require_relative "day_01"

        RSpec.describe Username::Year2024::Day01 do
          it "solves Part One" do
            input = <<~INPUT
              1
              2
              3
              4
            INPUT

            expect(described_class.part_one(input)).to eq(123)
          end

          it "solves Part Two", skip: "not implemented yet" do
            input = <<~INPUT
              5
              6
              7
              8
            INPUT

            expect(described_class.part_two(input)).to eq(456)
          end
        end
      RUBY
    )
  end
end
