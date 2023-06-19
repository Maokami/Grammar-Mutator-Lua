import json
import csv

# Load the result JSON files
with open("out_lua.json", "r") as f:
    lua_results = json.load(f)

with open("out_lua_jit.json", "r") as f:
    lua_jit_results = json.load(f)

with open("out_gopher_lua.json", "r") as f:
    gopher_lua_results = json.load(f)

# Prepare CSV output file
with open("diff_results.csv", "w", newline="") as csvfile:
    fieldnames = ["input_file", "lua_result", "lua_jit_result", "gopher_lua_result"]
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()

    # Loop over all files and compare results
    for filename in lua_results:
        lua_result = lua_results[filename]
        lua_jit_result = lua_jit_results[filename]
        gopher_lua_result = gopher_lua_results[filename]

        # If the results differ, write to CSV
        if (
            lua_result != lua_jit_result
            or lua_result != gopher_lua_result
            or lua_jit_result != gopher_lua_result
        ):
            writer.writerow(
                {
                    "input_file": filename,
                    "lua_result": lua_result,
                    "lua_jit_result": lua_jit_result,
                    "gopher_lua_result": gopher_lua_result,
                }
            )
