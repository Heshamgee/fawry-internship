#!/bin/bash

# Show help if --help is provided
if [[ "$1" == "--help" ]]; then
    echo "Usage: $0 [-n] [-v] search_string filename"
    echo "Options:"
    echo "  -n    Show line numbers"
    echo "  -v    Invert match"
    exit 0
fi

# Option parsing
show_line_numbers=false
invert_match=false

# Handle options
while getopts ":nv" opt; do
  case $opt in
    n)
      show_line_numbers=true
      ;;
    v)
      invert_match=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

# Argument checking
if [ "$#" -lt 2 ]; then
    echo "Error: Missing search string or filename."
    echo "Usage: $0 [-n] [-v] search_string filename"
    exit 1
fi

search="$1"
file="$2"

# File existence check
if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found."
    exit 1
fi

# Core logic
line_number=0
while IFS= read -r line; do
    ((line_number++))
    if [[ "$line" =~ $search ]]; then
        match=true
    else
        match=false
    fi

    # Case-insensitive match
    if echo "$line" | grep -iqF "$search"; then
        match=true
    else
        match=false
    fi

    # Invert match if -v
    if $invert_match; then
        match=! $match
        if ! echo "$line" | grep -iqF "$search"; then
            match=true
        else
            match=false
        fi
    fi

    if $match; then
        if $show_line_numbers; then
            echo "${line_number}:$line"
        else
            echo "$line"
        fi
    fi
done < "$file"
