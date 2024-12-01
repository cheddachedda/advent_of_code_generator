# Advent of Code Generator

A Ruby gem that generates daily puzzle templates for Advent of Code.

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
