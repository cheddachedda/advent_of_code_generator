# frozen_string_literal: true

require "webmock/rspec"

RSpec.describe AdventOfCodeGenerator::Scraper do
  describe "#puzzle_description" do
    before do
      stub_request(:get, "https://adventofcode.com/2024/day/1")
        .with(headers: { "Cookie" => "session=fake_session_key" })
        .to_return(body: "<article>Test puzzle description</article>")
    end

    it "fetches the puzzle description from adventofcode.com" do
      scraper = described_class.new(year: 2024, day: 1, session: "fake_session_key")

      expect(scraper.puzzle_description).to eq("<article>Test puzzle description</article>")
    end
  end

  describe "#input_data" do
    context "with a session key" do
      before do
        stub_request(:get, "https://adventofcode.com/2024/day/1/input")
          .with(headers: { "Cookie" => "session=fake_session_key" })
          .to_return(body: "1234\n5678\n")
      end

      it "fetches the input file from adventofcode.com" do
        scraper = described_class.new(year: 2024, day: 1, session: "fake_session_key")

        expect(scraper.input_data).to eq("1234\n5678\n")
      end

      it "caches the response" do
        scraper = described_class.new(year: 2024, day: 1, session: "fake_session_key")

        2.times { scraper.input_data }

        expect(WebMock).to have_requested(:get, "https://adventofcode.com/2024/day/1/input").once
      end
    end

    context "without a session key" do
      it "returns nil" do
        scraper = described_class.new(year: 2024, day: 1)

        expect(scraper.input_data).to be_nil
      end

      it "outputs a warning" do
        scraper = described_class.new(year: 2024, day: 1)

        expect { scraper.input_data }.to output(/No session key/).to_stderr
      end
    end
  end
end
