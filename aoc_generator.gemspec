# frozen_string_literal: true

require_relative "lib/advent_of_code_generator"

Gem::Specification.new do |spec|
  spec.name = "aoc_generator"
  spec.version = AdventOfCodeGenerator::VERSION
  spec.authors = ["Daniel Nguyen"]
  spec.email = ["daniel.n.q.nguyen@gmail.com"]

  spec.summary = "A Ruby gem that generates daily puzzle templates for Advent of Code."
  spec.description = <<~DESCRIPTION
    Automatically creates daily puzzle files and test templates for Advent of Code challenges,
    helping developers focus on solving the puzzles rather than project setup.
    Includes support for multiple years and customizable templates.
  DESCRIPTION
  spec.homepage = "https://github.com/cheddachedda/advent_of_code_generator"
  spec.required_ruby_version = ">= 3.3"

  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  gemspec = File.basename(__FILE__)
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |file|
      (file == gemspec) ||
        file.start_with?(*%w[spec/ .git .github appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "file_utils", "~> 1.1"
  spec.add_dependency "nokogiri", "~> 1.16"
  spec.add_dependency "thor", "~> 1.3"
end
