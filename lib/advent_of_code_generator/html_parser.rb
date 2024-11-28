# frozen_string_literal: true

require "nokogiri"

module AdventOfCodeGenerator
  # Converts HTML puzzle descriptions from adventofcode.com into markdown format.
  class HTMLParser
    def initialize(html_content)
      @html_content = html_content
    end

    def call
      {
        puzzle_description: part_descriptions.join("\n"),
        test_input:,
        test_expectations:
      }
    end

    private

    def part_descriptions
      @part_descriptions ||= articles.map do |node|
        process_article(node).join("\n")
      end
    end

    def test_input
      part_descriptions.map { |desc| desc.scan(/```sh\n(.*?)\n```/m) }.flatten
    end

    def test_expectations
      part_descriptions
        .flat_map { |desc| desc.scan(/\*\*`(.*?)`\*\*/) }
        .map do |matches|
          match = matches.first
          match&.match?(/\A\d+\z/) ? match.to_i : match
        end.compact
    end

    def articles
      doc = Nokogiri::HTML(@html_content)
      doc.css("article")
    end

    def process_article(article)
      article.children.map { |node| process_node(node) }.compact
    end

    def process_node(node)
      case node.name
      when "h2" then "## #{node.text}\n"
      when "ul" then "#{process_list(node, "-")}\n"
      when "ol" then"#{process_list(node, "1.")}\n"
      when "p" then "#{process_paragraph(node)}\n"
      when "pre" then "```sh\n#{node.text.strip}\n```\n"
      end
    end

    def process_list(list_node, marker)
      list_node.css("li").map do |item|
        "#{marker} #{process_paragraph(item)}"
      end.join("\n")
    end

    def process_paragraph(para)
      para.inner_html
          .gsub(%r{<a[^>]*href="([^"]*)"[^>]*>(.*?)</a>}, '[\2](\1)')
          .gsub(%r{<code><em>(.*?)</em></code>}, '**`\1`**')
          .gsub(%r{<em><code>(.*?)</code></em>}, '**`\1`**')
          .gsub(%r{<em.*?>(.*?)</em>}, '**\1**')
          .gsub(%r{<code>(.*?)</code>}, '`\1`')
          .gsub(/<[^>]*>/, "")
    end
  end
end
