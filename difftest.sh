#!/bin/bash

# get file count
cnt=$(ls ./minimized-corpus | wc -l)
echo $cnt files

# make sure output files exist and are empty
echo '{}' > out_lua.json
echo '{}' > out_lua_jit.json
echo '{}' > out_gopher_lua.json

# iterate over files
for filename in ./minimized-corpus/* ; do
    echo "Processing $filename"

    # add the debug function override at the beginning of the file
    sed -i '1s;^;debug = function() end\n;' "$filename"

    # run lua script and capture exit code
    ./lua "$filename"
    result=$?
    jq --arg file "$filename" --arg result "$result" '.[$file] = $result' out_lua.json > temp.json && mv temp.json out_lua.json

    # run luajit script, capture exit code and stderr
    luajit "$filename"
    result=$?
    jq --arg file "$filename" --arg result "$result" '.[$file] = $result' out_lua_jit.json > temp.json && mv temp.json out_lua_jit.json

    # run glua script, capture exit code and stderr
    ./glua "$filename"
    result=$?
    jq --arg file "$filename" --arg result "$result" '.[$file] = $result' out_gopher_lua.json > temp.json && mv temp.json out_gopher_lua.json

    # remove the debug function override from the file
    sed -i '1d' "$filename"

done
