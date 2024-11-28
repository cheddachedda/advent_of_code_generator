# frozen_string_literal: true

RSpec.describe AdventOfCodeGenerator::HTMLParser do
  context "with a simple article" do
    let(:input) do
      <<~HTML
        <article>
          <h2>--- Part One ---</h2>
          <p>Here is some <em>emphasised</em> text with a <a href="https://example.com">link</a>.</p>
          <pre><code>sample code\ngoes here</code></pre>
        </article>
      HTML
    end
    let(:expected_output) do
      <<~MARKDOWN.strip
        ## --- Part One ---

        Here is some **emphasised** text with a [link](https://example.com).

        ```sh
        sample code
        goes here
        ```
      MARKDOWN
    end

    specify do
      expect(described_class.new(input).call).to eq(expected_output)
    end
  end

  context "with code and emphasis combinations" do
    let(:input) do
      <<~HTML
        <article>
          <p>Text with <code><em>emphasised code</em></code> and <em><code>alternate format</code></em>.</p>
        </article>
      HTML
    end
    let(:expected_output) do
      <<~MARKDOWN.strip
        Text with **`emphasised code`** and **`alternate format`**.
      MARKDOWN
    end

    specify do
      expect(described_class.new(input).call).to eq(expected_output)
    end
  end

  context "with multiple articles" do
    let(:input) do
      <<~HTML
        <article>
          <h2>--- Part One ---</h2>
          <p>First part</p>
        </article>
        <article>
          <h2>--- Part Two ---</h2>
          <p>Second part</p>
        </article>
      HTML
    end
    let(:expected_output) do
      <<~MARKDOWN.strip
        ## --- Part One ---

        First part

        ## --- Part Two ---

        Second part
      MARKDOWN
    end

    specify do
      expect(described_class.new(input).call).to eq(expected_output)
    end
  end
end
