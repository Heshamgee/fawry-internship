#!/bin/bash

# Usage function
usage() {
    echo "Usage: $0 [-n] [-v] search_string filename"
    echo "Options:"
    echo "  -n    Show line numbers"
    echo "  -v    Invert match (show lines that do NOT match)"
    echo "  --help Show this help message"
    exit 1
}

# Check if no arguments or help requested
if [[ $# -eq 0 || "$1" == "--help" ]]; then
    usage
fi

# Initialize option flags
show_line_numbers=false
invert_match=false

# Parse options
while [[ "$1" == -* ]]; do
    case "$1" in
        -n) show_line_numbers=true ;;
        -v) invert_match=true ;;
        -vn|-nv)
            show_line_numbers=true
            invert_match=true
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
    shift
done

# After options, expect two arguments
if [[ $# -lt 2 ]]; then
    echo "Error: Missing search string or filename."
    usage
fi

search_string="$1"
file="$2"

# Check if file exists
if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' not found."
    exit 1
fi

# Read the file line by line
line_number=0
while IFS= read -r line; do
    ((line_number++))

    if [[ "$line" == *"$search_string"* ]]; then
        match=true
    else
        match=false
    fi

    # Invert match if needed
    if $invert_match; then
        if $match; then
            match=false
        else
            match=true
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
