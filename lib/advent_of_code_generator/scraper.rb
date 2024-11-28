# frozen_string_literal: true

require "net/http"
require_relative "html_parser"

module AdventOfCodeGenerator
  # Fetches puzzle descriptions and input data from adventofcode.com.
  class Scraper
    def initialize(options)
      @year = options[:year]
      @day = options[:day]
      @session_key = options[:session]
    end

    def puzzle_description
      warn "You'll need to provide a session key to scrape Part Two." unless @session_key

      uri = URI("https://adventofcode.com/#{@year}/day/#{@day}")
      response = Net::HTTP.get_response(uri, headers)

      response.body
    end

    def input_data
      return @input_data if @input_data
      return warn "No session key provided; unable to download data file." unless @session_key

      uri = URI("https://adventofcode.com/#{@year}/day/#{@day}/input")
      response = Net::HTTP.get_response(uri, headers)
      @input_data ||= response.body
    end

    private

    def headers
      return {} unless @session_key

      @headers ||= { cookie: "session=#{@session_key}" }
    end
  end
end
