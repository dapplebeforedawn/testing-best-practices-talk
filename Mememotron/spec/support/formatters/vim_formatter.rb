# http://fweepcode.blogspot.com/2013/03/faster-tdd-with-rspec-vim-and-quickfix.html

# Adapted from https://github.com/bronson/vim-runtest/blob/master/rspec_formatter.rb.
require 'rspec/core/formatters/base_text_formatter'

class VimFormatter < RSpec::Core::Formatters::BaseTextFormatter

  def example_failed example
    exception = example.execution_result[:exception]
    path = $1 if exception.backtrace.find do |frame|
      frame =~ %r{\b(spec/.*_spec\.rb:\d+)(?::|\z)}
    end
    message = format_message exception.message
    path    = format_caller path
    output.puts "#{path}: #{example.example_group.description.strip}" +
      "#{example.description.strip}: #{message.strip}" if path
  end

  def example_pending *args;  end
  def dump_failures *args; end
  def dump_pending *args; end
  def message msg; end
  def dump_summary *args; end
  def seed *args; end

private

  def format_message msg
    msg.gsub("\n", ' ')[0,80]
  end

end


# rspec --require=support/formatters/vim_formatter.rb --format VimFormatter --out quickfix.out  --format documentation
# :cexpr system('rspec --require=support/formatters/vim_formatter.rb --format VimFormatter')
# :cfile quickfix.out   "jumps to first error
# :cg quickfix.out      " same as :cfile, but no jump
# :cwindow

# guard :rspec, cmd: 'rspec --require=support/formatters/vim_formatter.rb --format VimFormatter --out quickfix.out  --format documentation' do
# end

