# This script checks for handles that do not match their BCLSCO redirect
# TODO: make this actually do something meaningful

require 'faraday'

class Array
  def each_with_prev_next &block
    [nil, *self, nil].each_cons(3, &block)
  end
end

responses = []
input = File.readlines('hdl_batch_file-working.txt')

input.each_with_prev_next do |prev, curr, nxt|
  if curr.include? 'https://'
    dest = curr[/https:\/\/bclsco.bc.edu\/catalog\/oai:dcollections.bc.edu:[0-9]+/]
    hdl = "https://hdl.handle.net/#{prev[/[0-9].*[0-9]/]}"
    response = Faraday.get(hdl).headers
    puts "The response headers for handle #{hdl} do not match the destination #{dest}" unless response['location'] == dest
  end
end
