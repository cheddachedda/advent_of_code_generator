# frozen_string_literal: true

require "thor"
require_relative "generator"
require_relative "scraper"

module AdventOfCodeGenerator
  # Command Line Interface for generating Advent of Code puzzle templates
  class CLI < Thor
    desc "generate", "Generate files for a new Advent of Code puzzle"

    method_option :year,
                  required: false,
                  aliases: "-y",
                  type: :numeric,
                  desc: "Defaults to the current year.",
                  default: Time.now.year

    method_option :day,
                  required: false,
                  aliases: "-d",
                  type: :numeric,
                  desc: "Defaults to the current day.",
                  default: Time.now.day

    method_option :username,
                  required: false,
                  aliases: "-u",
                  desc: "Files will be generated in a directory with this name. Useful for multi-user repos.",
                  default: "advent_of_code"

    method_option :session,
                  required: false,
                  aliases: "-s",
                  desc: "Your adventofcode.com session key. " \
                        "Necessary for scraping data files and specs for part two. " \
                        "Defaults to a AOC_SESSION environment variable if it exists.",
                  default: ENV.fetch("AOC_SESSION", nil)

    def generate
      scraped_data = AdventOfCodeGenerator::Scraper.new(options).call
      generator = AdventOfCodeGenerator::Generator.new(options, scraped_data)

      generator.call
    end

    def self.exit_on_failure?
      true
    end
  end
end
