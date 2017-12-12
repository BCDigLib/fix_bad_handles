require 'nokogiri'
require 'faraday'

oai_files = ARGV
handles = []
responses = {}

if ARGV.empty?
  puts "Usage: ruby find_bad_handles.rb path_to_oai_xml_file(s)"
  puts "e.g., ruby find_bad_handles.rb oai_files/*.xml"
  puts "\n"
end

oai_files.each do |oai_file|
  doc = Nokogiri::XML(File.open(oai_file)) do |config|
    config.options = Nokogiri::XML::ParseOptions::STRICT
  end

  # This is gross, but we need to remove all namespaces for Nokogiri to work
  results = doc.remove_namespaces!.xpath("//identifier[@type='hdl']/text()")
  results.each { |handle| handles << handle.to_s }
end

# Data scrubbing because some records include the handle twice as http and https
handles.delete_if { |handle| handle.match('http://') }
handles.delete('2345/2737')
handles = handles.sort.uniq

# This makes it easier to create the handle batch modify file
handles.map! { |handle| handle.gsub(/https:\/\/hdl.handle.net\//, '') }

handles.each do |handle|
  response = Faraday.get("https://hdl.handle.net/#{handle}")
  responses[handle] = response.headers['location']
end

# We need to remove the nil response so gsub! will work in the next block.
responses.delete_if { |handle, location| location.nil? }

responses.each do |handle, location|
  location.gsub!('http:', 'https:')

  # Write redirects to handle batch file
  File.open('hdl_batch_file.txt', 'a') do |file|
    file.write("MODIFY #{handle}\n")
    file.write("201 URL 86400 1110 UTF8 #{location}\n\n")
  end
end
