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
api_prefix = 'https://hdl.handle.net/api/handles/'
handles = []
results = {}

input.each { |line| handles << line.split(' ').last if line.start_with?('MODIFY') }

handles.each do |handle|
  endpoint = api_prefix + handle
  response = JSON.parse(Faraday.get(endpoint).body)

  url_node = response["values"].select { |node| node["type"] == "URL" }[0]
  url_index = url_node["index"]
  url_destination = url_node["data"]["value"]

  results[handle] = { index: url_index, url: url_destination }
end

File.open('output.txt', 'w') do |file|
  results.each do |handle, value|
    file.write("#{handle}\t#{value[:index]}\t#{value[:url]}\n\n")
  end
end