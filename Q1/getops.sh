#!/bin/bash

# Usage instructions
usage() {
    echo "Usage: $0 [-n] [-v] search_string filename"
    echo ""
    echo "Options:"
    echo "  -n    Show line numbers"
    echo "  -v    Invert match (show lines that do NOT match)"
    echo "  --help Show this help message"
    exit 1
}

# Handle no arguments
if [[ $# -eq 0 ]]; then
    usage
fi

# Handle --help
if [[ "$1" == "--help" ]]; then
    usage
fi

# Initialize flags
show_line_numbers=false
invert_match=false

# Parse options
while getopts ":nv" opt; do
    case "$opt" in
        n) show_line_numbers=true ;;
        v) invert_match=true ;;
        \?) 
            echo "Error: Invalid option: -$OPTARG"
            usage
            ;;
    esac
done

shift $((OPTIND-1))

# After options, there must be 2 arguments left
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

# Build the grep command dynamically
grep_options=""

if $invert_match; then
    grep_options="${grep_options} -v"
fi

if $show_line_numbers; then
    grep_options="${grep_options} -n"
fi

# Now run the grep
grep $grep_options -- "$search_string" "$file"
