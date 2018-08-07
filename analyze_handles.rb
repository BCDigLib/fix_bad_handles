# Confirms URL index and destination of existing handles. Takes a handle batch 
# file with one or more MODIFY statements as input.

require 'faraday'
require 'json'

if ARGV.empty?
  puts "Usage: ruby analyze_handles.rb path/to/handle_batch_file.txt"
  puts "\n"
  exit
end

input = File.readlines(ARGV[0])
api_prefix = 'http://hdl.handle.net/api/handles/'

input.each do |line|
end