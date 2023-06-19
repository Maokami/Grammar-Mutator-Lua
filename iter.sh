#!/bin/bash

# get file count
cnt=$(ls ./minimized-corpus | wc -l)
echo $cnt files

# make sure output files exist and are empty
: > out_lua.txt
: > out_lua_jit.txt
: > out_gopher_lua.txt

# iterate over files
for filename in ./minimized-corpus/* ; do
    echo "Processing $filename"

    # add the debug function override at the beginning of the file
    sed -i '1s;^;debug = function() end\n;' "$filename"

    # run lua script and capture exit code
    ./lua "$filename"
    result=$?
    echo "$filename: $result" >> out_lua.txt

    # run luajit script, capture exit code and stderr
    luajit "$filename"
    result=$?
    echo "$filename: $result" >> out_lua_jit.txt

    # run glua script, capture exit code and stderr
    ./glua "$filename"
    result=$?
    echo "$filename: $result" >> out_gopher_lua.txt

    # remove the debug function override from the file
    sed -i '1d' "$filename"

done