# Advent of Code Generator

A Ruby gem that generates daily puzzle templates for Advent of Code with automatically scraped puzzle descriptions and input data.

## Installation

```sh
gem install advent_of_code_generator
```

### Prerequisites

- RSpec: This gem uses RSpec for testing. If you haven't installed it yet, run:

  ```sh
  gem install rspec
  ```

- Or optionally, set it up as you would for a normal Ruby project by adding `rspec` to your `Gemfile` and running `bundle install`.

### Setting up your session key

1. Log in to [Advent of Code](https://adventofcode.com)
2. In your browser's developer tools, find the `session` cookie value
   - Chrome: DevTools (F12) > Application > Cookies > adventofcode.com
   - Firefox: DevTools (F12) > Storage > Cookies
3. Store the session key in your environment:

```sh
# Add to your ~/.bashrc, ~/.zshrc, or equivalent
export AOC_SESSION='your_session_key_here'
```

## Usage

```sh
  # With default arguments
  aoc generate

  # With custom arguments
  aoc generate -y=2023 -d=1 -u=cheddachedda -s=$SESSION_KEY
```

### Options

```sh
  -y, [--year=N]             # Defaults to the current year.
  -d, [--day=N]              # Defaults to the current day.
  -u, [--username=USERNAME]  # Files will be generated in a directory with this name. Useful for multi-user repos.
                             # Default: advent_of_code
  -s, [--session=SESSION]    # Your adventofcode.com session key. Necessary for scraping data files and specs for part two.
                             # Default: reads AOC_SESSION environment variable if it exists.
```

## Generated file structure

```sh
adventofcode/
│
└── year_2024/
    |
    └── day_01/
        ├── day_01.rb
        ├── day_01_spec.rb
        ├── data.txt
        └── PUZZLE_DESCRIPTION.md
```

## Generated File Contents

The generator creates the following files with basic templates:

### `day_XX.rb`

```ruby
class DayXX
  def part_one(input)
    # Your solution for Part One
  end

  def part_two(input)
    # Your solution for Part Two
  end
end
```

### `day_XX_spec.rb`

```ruby
RSpec.describe Cheddachedda::YearXXXX::DayXX do
  it "solves Part One" do
    input = <<~INPUT
      1abc2
      pqr3stu8vwx
      a1b2c3d4e5f
      treb7uchet
    INPUT

    expect(described_class.part_one(input)).to eq(142)
  end

  # it "solves Part Two" do
  #   input = <<~INPUT
  #     two1nine
  #     eightwothree
  #     abcone2threexyz
  #     xtwone3four
  #     4nineeightseven2
  #     zoneight234
  #     7pqrstsixteen
  #   INPUT

  #   expect(described_class.part_two(input)).to eq(281)
  # end
end
```

## Acknowledgments

- Thanks to [Eric Wastl](https://twitter.com/ericwastl) for creating [Advent of Code](https://adventofcode.com)
