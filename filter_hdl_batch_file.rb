# This script filters the results of find_bad_handles.rb to create a handle
# batch file that modifies only handles that link directly to DigiTool

class Array
  def each_with_prev_next &block
    [nil, *self, nil].each_cons(3, &block)
  end
end

handles = []
input = File.readlines('hdl_batch_file.txt')

input.each_with_prev_next do |prev, curr, nxt|
  if curr.include? "https://dcollections"
    handles << prev
    handles << curr
    handles << nxt
  end
end

handles.each do |handle|
  File.open('hdl_batch_file-working.txt', 'a') do |file|
    file.write(handle)
  end
end
