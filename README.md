This repo includes various scripts to fix handles that point to DigiTool and/or
use HTTP instead of HTTPS.

This code was written to work specifically with OAI XML from our 
Digital Commonwealth feed. It should be carefully reviewed before adapting 
for another use.

#### find_bad_handles.rb
Parses one or more OAI XML files to locate handles, changes the
URLs to use HTTPS, then generates a text file to batch redirect the files.

#### filter_hdl_batch_file.rb
Iterates through the output of find_bad_handles.rb and creates a new batch file
containing only the handles that point to DigiTool.

#### transform_hdl_batch_file.sh
Transforms the output of filter_hdl_batch_file.rb to point to BCLSCO records 
instead of DigiTool.
