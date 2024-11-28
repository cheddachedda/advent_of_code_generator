# frozen_string_literal: true

require "fileutils"

module AdventOfCodeGenerator
  # Creates directory structure and files for daily Advent of Code puzzles:
  #
  # Generates a file structure like:
  #
  #   username/
  #   │
  #   └── year_2024/
  #       |
  #       └── day_01/
  #           ├── day_01.rb
  #           ├── day_01_spec.rb
  #           ├── data.txt
  #           └── README.md
  #
  class Generator
    FileData = Struct.new(:path, :content)

    def initialize(options, scraped_data)
      @year = options[:year].to_s
      @day = options[:day].to_s.rjust(2, "0") # Ensures day is two digits (e.g., "01" instead of "1")
      @username = options[:username].gsub(/[_\-\.\s]/, "")
      @scraped_data = scraped_data
    end

    def call
      FileUtils.mkdir_p(daily_directory)

      [readme, data_file, main_file, spec_file].each do |file_data|
        next if File.exist?(file_data.path)

        File.write(file_data.path, file_data.content)
      end
    end

    private

    def daily_directory
      @daily_directory ||= "#{@username}/year_#{@year}/day_#{@day}"
    end

    def readme
      path = "#{daily_directory}/README.md"
      content = @scraped_data[:puzzle_description]

      FileData.new(path, content)
    end

    def data_file
      path = "#{daily_directory}/data.txt"
      content = @scraped_data[:input_data]

      FileData.new(path, content)
    end

    def main_file
      path = "#{daily_directory}/day_#{@day}.rb"
      content = <<~RUBY
        # frozen_string_literal: true

        module #{@username.capitalize}
          module Year#{@year}
            class Day#{@day}
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

      FileData.new(path, content)
    end

    def spec_file
      path = "#{daily_directory}/day_#{@day}_spec.rb"
      content = <<~RUBY
        # frozen_string_literal: true

        require_relative "day_#{@day}"

        RSpec.describe #{@username.capitalize}::Year#{@year}::Day#{@day} do
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

      FileData.new(path, content)
    end
  end
end
