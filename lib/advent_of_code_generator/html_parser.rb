# frozen_string_literal: true

require "nokogiri"

module AdventOfCodeGenerator
  # Converts HTML puzzle descriptions from adventofcode.com into markdown format.
  class HTMLParser
    def initialize(input)
      @input = input
    end

    def call
      articles.map do |node|
        process_article(node)
      end.join("\n").strip
    end

    private

    def articles
      doc = Nokogiri::HTML(@input)
      doc.css("article")
    end

    def process_article(article)
      article.children.map { |node| process_node(node) }.compact
    end

    def process_node(node)
      case node.name
      when "h2"
        "## #{node.text}\n"
      when "p"
        "#{process_paragraph(node)}\n"
      when "pre"
        "```sh\n#{node.text.strip}\n```\n"
      end
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
