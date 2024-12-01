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
  #           └── PUZZLE_DESCRIPTION.md
  #
  class Generator
    FileData = Struct.new(:path, :content, :require_session, :allow_overwrite)

    def initialize(options, scraped_data)
      @year = options[:year].to_s
      @day = options[:day].to_s.rjust(2, "0") # Ensures day is two digits (e.g., "01" instead of "1")
      @username = options[:username].gsub(/[_\-\.\s]/, "")
      @session = options[:session]
      @scraped_data = scraped_data
    end

    def call
      FileUtils.mkdir_p(daily_directory)

      [puzzle_description, data_file, main_file, spec_file].each do |file_data|
        generate_file(file_data)
      end
    end

    private

    def daily_directory
      @daily_directory ||= "#{@username}/year_#{@year}/day_#{@day}"
    end

    def generate_file(file_data)
      return skip_file(file_data.path) if file_data.require_session && @session.nil?
      return skip_file(file_data.path) if File.exist?(file_data.path) && !file_data.allow_overwrite

      File.write(file_data.path, file_data.content)
      puts "    \e[32mcreate\e[0m  #{file_data.path}"
    end

    def skip_file(path)
      puts "      \e[33mskip\e[0m  #{path}"
    end

    def puzzle_description
      path = "#{daily_directory}/PUZZLE_DESCRIPTION.md"
      content = @scraped_data[:puzzle_description]

      FileData.new(path, content, false, true)
    end

    def data_file
      path = "#{daily_directory}/data.txt"
      content = @scraped_data[:input_data]

      FileData.new(path, content, true, false)
    end

    def main_file
      path = "#{daily_directory}/day_#{@day}.rb"
      content = <<~RUBY
        # frozen_string_literal: true

        module #{@username.capitalize}
          module Year#{@year}
            class Day#{@day}
              def self.part_one(input)
                # Your solution for Part One
              end

              def self.part_two(input)
                # Your solution for Part Two
              end
            end
          end
        end
      RUBY

      FileData.new(path, content, false, false)
    end

    def spec_file
      path = "#{daily_directory}/day_#{@day}_spec.rb"
      input, expectations = @scraped_data.values_at(:test_input, :test_expectations)
      input ||= ["", ""]
      content = <<~RUBY
        # frozen_string_literal: true

        require_relative "day_#{@day}"

        RSpec.describe #{@username.capitalize}::Year#{@year}::Day#{@day} do
          it "solves Part One" do
            input = <<~INPUT
              #{input[0]&.gsub("\n", "\n      ")}
            INPUT

            expect(described_class.part_one(input)).to eq(#{expectations[0]})
          end

          # it "solves Part Two" do
          #   input = <<~INPUT
          #     #{input[1]&.gsub("\n", "\n  #     ")}
          #   INPUT

          #   expect(described_class.part_two(input)).to eq(#{expectations[1]})
          # end
        end
      RUBY

      FileData.new(path, content, false, false)
    end
  end
end
