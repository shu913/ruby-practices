#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

class Wc
  def main
    option = ARGV.getopts('l')
    @files = ARGV

    if @files.empty?
      show_stdin(option)
    else
      @files.each do |file|
        show_wc_format(file, option)
      end

      total_wc_format(@files, option) if @files.size >= 2
    end
  end

  def show_stdin(option)
    input = $stdin.read

    print input.lines.count.to_s.rjust(8)
    return if option['l']

    print input.split(/\s+/).size.to_s.rjust(8)
    print input.bytesize.to_s.rjust(8)
  end

  def show_wc_format(file, option)
    print count_line(file).to_s.rjust(8)
    unless option['l']
      print count_word(file).to_s.rjust(8)
      print count_bytesize(file).to_s.rjust(8)
    end
    puts " #{file}"
  end

  def count_line(file)
    File.read(file).count("\n")
  end

  def count_word(file)
    File.read(file).split(/\s+/).size
  end

  def count_bytesize(file)
    File.read(file).bytesize
  end

  def total_wc_format(files, option)
    print count_total_lines(files).to_s.rjust(8)
    unless option['l']
      print count_total_words(files).to_s.rjust(8)
      print count_total_bytesizes(files).to_s.rjust(8)
    end
    puts ' total'
  end

  def count_total_lines(files)
    files.sum { |file| count_line(file) }
  end

  def count_total_words(files)
    files.sum { |file| count_word(file) }
  end

  def count_total_bytesizes(files)
    files.sum { |file| count_bytesize(file) }
  end
end

wc = Wc.new
wc.main
