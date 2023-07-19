#!/bin/bash
copyright_file="copyright.txt"
expected_first_line=$(head --lines=1 $copyright_file)
temp_file=temp.txt

shopt -s globstar
for current_file in src/*.cpp* src/**/*.cpp*; do
    [ -f "$current_file" ] || break
    #echo "doing someing to $current_file"
    current_first_line=$(head --lines=1 $current_file)
    if [ "$current_first_line" != "$expected_first_line" ]; then
        cat "$copyright_file" "$current_file" > $temp_file && mv $temp_file $current_file
    fi
done

#documentation
doxygen
cd documentation/latex
make


