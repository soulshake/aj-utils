#!/usr/bin/env ruby
# Adapted from:
# https://gist.github.com/jcsalterego/8dbcebe23f5434c58a8859eaeea9a728
# https://twitter.com/jcsalterego/status/801574032583917568

require 'fileutils'

FORMAT = "{{author}}: {{message}}"
TIMESTAMP_RE = /\[[0-9:A-Z ]+\]/
DAY_MARKER_RE = /(-){5}[^-]+(-){5}/

# try to handle both linux and osx
if (/linux/ =~ RUBY_PLATFORM) != nil
  input = `xclip -out`
  output = 'xclip -in'
elsif (/darwin/ =~ RUBY_PLATFORM) != nil
  input = `pbpaste`
  output = 'pbcopy'
end

last_author = "???"

# Read from the clipboard, remove day marker lines and split by double newlines
lines = input.
      split(/\n/).
      reject{|line| line =~ DAY_MARKER_RE}.
      join("\n").
      split(/\n\n/)

# Keep track of the length of the longest author name so we can align messages for printing later
maxlen = 0

# Figure out which lines are from a new author.
lines = lines.map(&:strip).map do |line|

  # A timestamp is displayed before each message, so use that to split into individual messages
  if line =~ TIMESTAMP_RE
    author = last_author
    words = line.split(TIMESTAMP_RE).map(&:strip).join

    # The first message from a given author is in the following format:
    # author <TAB> message
    # Subsequent messages are in the same format but without the leading `author <TAB>`.
    if words.include?("\t")
      # Transform to [author, words words words]
      words = words.split("\t", 2)
    else
      # If there's no <tab> then there are two possibilities:
      # 1. the author has started a message with a newline, or
      # 2. This is not the first message from that author
      x = words.split("\n", 2)
      if !x.first.include?(' ')
        # Transform to [author, words words words]
        words = words.split("\n", 2)
      else
        # Transform to [words words words]
        words = [words]
      end
    end

  else
    words = ["{MAXLEN_REPLACE}", line]
  end

  if words.size == 2
    last_author = words[0]
    message = words[1]
  elsif words.size == 1
    message = words[0]
  end
  message = message.gsub("\n", "\n" + "{MAXLEN_REPLACE}  ") #"".ljust(maxlen + 2))
  maxlen = [maxlen, last_author.length].max
  {:author=>last_author, :message=>message}
end

if lines.compact.empty?
  $stderr.puts "No slack-like lines found on your clipboard. Bailing!"
  puts input
  exit 1
end

paste = lines.map {|line|
  next if line.nil? || line.empty?
  formatted = FORMAT.dup
  line.each do |k, v|
    v = line[k].rjust(maxlen) if k == :author
    formatted = formatted.gsub(/{{#{k}}}/, v)
    formatted = formatted.gsub("{MAXLEN_REPLACE}", "".rjust(maxlen))
    formatted = formatted.gsub(":", " ") if ["{MAXLEN_REPLACE}", ""].include?(v)
  end
  formatted
}.join("\n")

if ARGV[0] == "-x"
  tmp = "/tmp/#{$$}.tmp"
  fh = File.open(tmp, "w")
  fh.puts(paste)
  fh.close
  `cat #{tmp} | #{output}`
  FileUtils.rm(tmp)
else
  puts paste
end
