# frozen_string_literal: true

RSpec.describe AdventOfCodeGenerator::CLI do
  subject(:cli) { described_class.new }

  describe "#generate" do
    context "with no options" do
      it "generates a workspace with the default options", :aggregate_failures do
        year = Time.now.year
        day = Time.now.day.to_s.rjust(2, "0")

        system("exe/aoc generate")

        expect(Dir.exist?("adventofcode/year_#{year}/day_#{day}")).to be true

        FileUtils.rm_rf("adventofcode")
      end
    end

    context "with custom options" do
      it "generates a workspace with the custom options" do
        system("exe/aoc generate -y=2022 -d=8 -u=testuser")

        expect(Dir.exist?("testuser/year_2022/day_08")).to be true

        FileUtils.rm_rf("testuser")
      end
    end
  end

  describe ".exit_on_failure?" do
    it "returns true" do
      expect(described_class.exit_on_failure?).to be true
    end
  end
end
