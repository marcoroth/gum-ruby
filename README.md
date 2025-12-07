# Gum for Ruby

<p>
  <a href="https://github.com/marcoroth/gum-ruby" target="_blank"><img src="assets/logo.png" alt="Gum Image" width="450" /></a>
</p>

Ruby wrapper for [Charm's Gum](https://github.com/charmbracelet/gum). A tool for glamorous scripts.

This gem bundles the `gum` binary and provides an idiomatic Ruby API for all gum commands.

## Installation

**Add to your Gemfile:**

```bash
bundle add gum
```

**Or install directly:**

```bash
gem install gum
```

## Usage

```ruby
require "gum"
```

### Input

**Prompt for single-line input:**

```ruby
name = Gum.input(placeholder: "Enter your name")
```

**Password input (masked):**

```ruby
password = Gum.input(password: true)
```

**With default value and custom prompt:**

```ruby
email = Gum.input(value: "user@", prompt: "> ", placeholder: "email")
```

**With character limit:**

```ruby
code = Gum.input(placeholder: "Enter code", char_limit: 6)
```

### Write

**Prompt for multi-line text input (Ctrl+D to submit):**

```ruby
description = Gum.write(placeholder: "Enter description...")
```

**With dimensions:**

```ruby
notes = Gum.write(width: 80, height: 10, header: "Notes")
```

**With line numbers:**

```ruby
content = Gum.write(show_line_numbers: true)
```

### Choose

**Single selection (array):**

```ruby
color = Gum.choose(["red", "green", "blue"])
```

**Single selection (splat):**

```ruby
color = Gum.choose("red", "green", "blue")
```

**Multiple selection with limit:**

```ruby
colors = Gum.choose(["red", "green", "blue"], limit: 2)
```

**Unlimited selection:**

```ruby
colors = Gum.choose(["red", "green", "blue"], no_limit: true)
```

**With header and custom height:**

```ruby
choice = Gum.choose(options, header: "Pick one:", height: 10)
```

**Pre-selected items:**

```ruby
choice = Gum.choose(["a", "b", "c"], selected: ["b"])
```

### Filter

**Single selection (array):**

```ruby
file = Gum.filter(Dir.glob("**/*.rb"))
```

**Single selection (splat):**

```ruby
file = Gum.filter("file1.rb", "file2.rb", "file3.rb")
```

**Multiple selection:**

```ruby
files = Gum.filter(Dir.glob("*"), limit: 5)
```

**Unlimited selection:**

```ruby
files = Gum.filter(items, no_limit: true)
```

**With placeholder and height:**

```ruby
selection = Gum.filter(items, placeholder: "Search...", height: 20)
```

**Disable fuzzy matching for exact search:**

```ruby
result = Gum.filter(items, fuzzy: false)
```

### Confirm

**Ask for yes/no confirmation:**

```ruby
if Gum.confirm("Delete file?")
  File.delete(path)
end
```

**With default value:**

```ruby
proceed = Gum.confirm("Continue?", default: true)
```

**Custom button labels:**

```ruby
Gum.confirm("Save changes?", affirmative: "Save", negative: "Discard")
```

### File

**Start from current directory:**

```ruby
path = Gum.file
```

**Start from specific directory:**

```ruby
path = Gum.file("~/Documents")
```

**Show hidden files:**

```ruby
path = Gum.file(all: true)
```

**Only show directories:**

```ruby
dir = Gum.file(directory_only: true)
```

### Pager

**Scroll through content:**

```ruby
Gum.pager(File.read("README.md"))
```

**With line numbers:**

```ruby
Gum.pager(content, show_line_numbers: true)
```

**Soft wrap long lines:**

```ruby
Gum.pager(content, soft_wrap: true)
```

### Spin

**With shell command:**

```ruby
Gum.spin("Installing...", command: "npm install")
```

**With Ruby block:**

```ruby
result = Gum.spin("Processing...") do
  expensive_computation
end
```

**Custom spinner type:**

```ruby
Gum.spin("Loading...", spinner: :dot, command: "sleep 5")
```

Available spinner types: `:line`, `:dot`, `:minidot`, `:jump`, `:pulse`, `:points`, `:globe`, `:moon`, `:monkey`, `:meter`, `:hamburger`

### Style

**Basic styling:**

```ruby
styled = Gum.style("Hello", foreground: "212", bold: true)
```

**With border:**

```ruby
box = Gum.style("Content", border: :double, padding: "1 2")
```

**Multiple lines with alignment:**

```ruby
styled = Gum.style("Line 1", "Line 2", align: :center, width: 50)
```

**Full styling example:**

```ruby
styled = Gum.style(
  "Bubble Gum",
  foreground: "212",
  border: :double,
  border_foreground: "212",
  align: :center,
  width: 50,
  margin: "1 2",
  padding: "2 4"
)
```

Available border types: `:none`, `:hidden`, `:rounded`, `:double`, `:thick`, `:normal`

### Join

Join text blocks horizontally or vertically:

```ruby
box1 = Gum.style("A", border: :rounded, padding: "1 3")
box2 = Gum.style("B", border: :rounded, padding: "1 3")
```

**Horizontal join (default):**

```ruby
combined = Gum.join(box1, box2)
```

**Vertical join:**

```ruby
stacked = Gum.join(box1, box2, vertical: true)
```

**With alignment:**

```ruby
aligned = Gum.join(box1, box2, vertical: true, align: :center)
```

### Format

**Markdown:**

```ruby
Gum.format("# Hello\n- Item 1\n- Item 2", type: :markdown)
```

**Template (see Termenv docs for helpers):**

```ruby
Gum.format('{{ Bold "Hello" }} {{ Color "99" "0" " World " }}', type: :template)
```

**Emoji:**

```ruby
Gum.format("I :heart: Ruby :gem:", type: :emoji)
# => "I ❤️ Ruby 💎"
```

**Shorthand methods:**

```ruby
Gum::Format.markdown("# Hello")
Gum::Format.emoji("I :heart: Ruby")
```

### Table

**From array of arrays:**

```ruby
data = [["Alice", "30"], ["Bob", "25"]]
selection = Gum.table(data, columns: %w[Name Age])
```

**Just print (no selection):**

```ruby
Gum.table(data, columns: %w[Name Age], print: true)
```

**From CSV string:**

```ruby
Gum.table(File.read("data.csv"))
```

**With custom border:**

```ruby
Gum.table(data, columns: %w[Name Age], border: :rounded)
```

### Log

**Basic logging:**

```ruby
Gum.log("Application started", level: :info)
```

**Structured logging with key-value pairs:**

```ruby
Gum.log("User created", level: :info, user_id: 123, email: "user@example.com")
```

**With timestamp:**

```ruby
Gum.log("Error occurred", level: :error, time: :rfc822)
```

**Shorthand methods:**

```ruby
Gum::Log.debug("Debug message")
Gum::Log.info("Info message")
Gum::Log.warn("Warning message")
Gum::Log.error("Error message", code: 500)
```

Available log levels: `:debug`, `:info`, `:warn`, `:error`, `:fatal`

## Styling Options

Most commands support styling options as hashes. Common style properties include:

```ruby
{
  foreground: "212",        # ANSI color code, hex (#ff0000), or name
  background: "0",
  bold: true,
  italic: true,
  underline: true,
  strikethrough: true,
  faint: true,
}
```

**Example with input styling:**

```ruby
Gum.input(
  placeholder: "Enter name",
  cursor: { foreground: "#FF0" },
  prompt_style: { foreground: "#0FF" }
)
```

## Environment Variables

- `GUM_INSTALL_DIR` - Override the path to the gum binary

## Raw Command Execution

For commands not covered by the Ruby API, you can execute gum directly:

```ruby
Gum.execute("choose", "a", "b", "c", "--limit", "2")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Building Platform Gems

```bash
rake gem:ruby           # Build pure Ruby gem (no binary)
rake gem:arm64-darwin   # Build macOS ARM64 gem
rake gem:x86_64-darwin  # Build macOS Intel gem
rake gem:arm64-linux    # Build Linux ARM64 gem
rake gem:x86_64-linux   # Build Linux x86_64 gem
rake package            # Build all platform gems
rake download           # Download all binaries
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcoroth/gum-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Acknowledgements

- [Charm](https://charm.sh/) for creating the amazing [gum](https://github.com/charmbracelet/gum) tool
- Inspired by [`litestream-ruby`](https://github.com/fractaledmind/litestream-ruby) for the native binary packaging approach
