#!/bin/sh

# This script creates a handle batch file that redirects DigiTool links to BCLSCO.

sed -i '' 's/https:\/\/.*=\([0-9]\{6\}\).*$/https:\/\/bclsco.bc.edu\/catalog\/oai:dcollections\.bc\.edu:\1/g' 'hdl_batch_file-working.txt' 
