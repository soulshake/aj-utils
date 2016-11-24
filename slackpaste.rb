#!/usr/bin/env ruby

# https://gist.github.com/jcsalterego/8dbcebe23f5434c58a8859eaeea9a728
# https://twitter.com/jcsalterego/status/801574032583917568

require 'fileutils'

FORMAT = "{{author}}: {{message}}"
TIMESTAMP_RE = /\[[0-9:A-Z ]+\]/
DAY_MARKER_RE = /(-){5}[^-]+(-){5}/

# linux
if (/linux/ =~ RUBY_PLATFORM) != nil
  input = `xclip -out`
  output = 'xclip -in'
elsif (/darwin/ =~ RUBY_PLATFORM) != nil
  input = `pbpaste`
  output = 'pbcopy'
end

require 'pry'
#binding.pry

last_author = "???"

lines = input.
      split(/\n/).
      reject{|line| line =~ DAY_MARKER_RE}.
      join("\n").
      split(/\n\n/)

maxlen = 0

lines = lines.map(&:strip).map do |line|
  if line =~ TIMESTAMP_RE
    author = last_author
    words = line.split(TIMESTAMP_RE).map(&:strip).join

    # line format: author <TAB> message
    if words.include?("\t")
      words = words.split("\t", 2)
    else
      # if there's no <tab>, and there's a newline right after the first word, maybe the author has started a message with a newline
      x = words.split("\n", 2)
      if !x.first.include?(' ')
        words = words.split("\n", 2)
      else
        words = [words]
      end
    end

  else
    words = [last_author, line]
  end

  if words.size == 2
    last_author = words[0]
    message = words[1]
  elsif words.size == 1
    message = words[0]
  end
  message = message.gsub("\n", "\n" + "".ljust(maxlen + 2))
  maxlen = [maxlen, last_author.length].max
  {:author=>last_author, :message=>message}
end

lines = lines.reject{|line| line.nil?}

if lines.compact.empty?
  $stderr.puts "Bailing!"
  puts input
  exit 1
end

paste = lines.map {|line|
  next if line.nil? || line.empty?
  formatted = FORMAT.dup
  line.each do |k, v|
    formatted = formatted.gsub(":", " ") if v == ""
    v = line[k].rjust(maxlen) if k == :author
    formatted = formatted.gsub(/{{#{k}}}/, v)
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
