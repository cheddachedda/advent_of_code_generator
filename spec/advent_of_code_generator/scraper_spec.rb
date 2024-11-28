# frozen_string_literal: true

require "webmock/rspec"

RSpec.describe AdventOfCodeGenerator::Scraper do
  subject(:scraper) { described_class.new(year: 2024, day: 1, session: "fake_session_key") }

  before do
    stub_request(:get, "https://adventofcode.com/2024/day/1")
      .to_return(body: "<article><p>Test puzzle description<p></article>")

    stub_request(:get, "https://adventofcode.com/2024/day/1/input")
      .to_return(body: "1234\n5678")
  end

  context "when a session key is provided" do
    subject(:scraper) { described_class.new(year: 2024, day: 1, session: "fake_session_key") }

    it "returns puzzle description and input data" do
      result = scraper.call

      expect(result).to eq(
        puzzle_description: "<article><p>Test puzzle description<p></article>",
        input_data: "1234\n5678"
      )
    end
  end

  context "when no session key is provided" do
    subject(:scraper) { described_class.new(year: 2024, day: 1) }

    it "returns partial data" do
      expect(scraper.call).to include(
        puzzle_description: "<article><p>Test puzzle description<p></article>",
        input_data: nil
      )
    end

    it "does not scrape the input" do
      scraper.call

      expect(WebMock).not_to have_requested(:get, "https://adventofcode.com/2024/day/1/input")
    end

    it "warns about a missing session key" do
      expect { scraper.call }.to output(/No session key provided/).to_stderr
    end
  end
end
