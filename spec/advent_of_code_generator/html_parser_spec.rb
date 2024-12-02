# frozen_string_literal: true

RSpec.describe AdventOfCodeGenerator::HTMLParser do
  let(:result) { described_class.new(html_content).call }
  let(:html_content) do
    <<~HTML
      <article>
        <h2>--- Part One ---</h2>
        <p>Here's a normal paragraph with <em>emphasised text</em> and a <a href="https://example.com">link</a>.</p>
        <p>Here's some <code>inline code</code> and <em><code>123</code></em>.</p>
        <p>Another variation with <code><em>456</em></code>.</p>
        <pre><code>sample\ntest\ninput</code></pre>
        <ul>
          <li>First bullet point</li>
          <li>Second with <code>inline code</code></li>
        </ul>
        <ol>
          <li>First numbered item</li>
          <li>Second with <em>emphasis</em></li>
        </ol>
      </article>
      <article>
        <h2>--- Part Two ---</h2>
        <p>Part two with <code><em>test value</em></code> and more text.</p>
        <pre><code>more\ntest\ninput</code></pre>
      </article>
    HTML
  end

  it "converts HTML to formatted markdown" do
    expected_markdown = <<~MARKDOWN
      ## --- Part One ---

      Here's a normal paragraph with **emphasised text** and a [link](https://example.com).

      Here's some `inline code` and **`123`**.

      Another variation with **`456`**.

      ```sh
      sample
      test
      input
      ```

      - First bullet point
      - Second with `inline code`

      1. First numbered item
      1. Second with **emphasis**

      ## --- Part Two ---

      Part two with **`test value`** and more text.

      ```sh
      more
      test
      input
      ```
    MARKDOWN

    expect(result[:puzzle_description]).to eq(expected_markdown)
  end

  it "extracts test inputs from pre-formatted code blocks" do
    expect(result[:test_input]).to eq(%W[sample\ntest\ninput more\ntest\ninput])
  end

  it "extracts test expectations from emphasised code blocks" do
    expect(result[:test_expectations]).to eq([456, "test value"])
  end
end
