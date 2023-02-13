#!/bin/bash

# Set default regex patterns
patterns=( "login" "email" "password" "username" "admin" "comment" )

# Prompt user for URLs
echo "Enter URLs to search, separated by spaces:"
read -a URLs

# Prompt user for file extension to search
echo "Enter file extension to search (css, php, text, html, image):"
read extension

# Check if user wants to input custom regex
echo "Do you want to input custom regex patterns? (y/n)"
read choice

if [ "$choice" == "y" ]; then
  echo "Enter regex patterns, separated by spaces:"
  read -a patterns
fi

# Loop through each URL
for URL in "${URLs[@]}"; do
  echo "---------------------------------------------------"
  echo "Summary: "
  echo "---------------------------------------------------"
  echo "URL: $URL"
  echo "File extension: $extension"
  echo "Regex patterns: ${patterns[@]}"
  echo "---------------------------------------------------"

  # Search for the regex patterns in the URL
  for pattern in "${patterns[@]}"; do
    echo "Searching for pattern: $pattern"

    if [ "$extension" == "image" ]; then
      # Search for images with odd names
      wget --recursive --no-parent --reject="*.html*" $URL
      results=$(grep -r "$pattern" * | grep -v "\.html")
    else
      # Search for specified file extension
      wget --recursive --no-parent --accept="*.$extension" $URL
      results=$(grep -r "$pattern" *)
    fi

    # Print results in a clean and readable format
    if [ -z "$results" ]; then
      echo "No results found."
    else
      while read -r line; do
        file=$(echo $line | awk -F ":" '{print $1}')
        match=$(echo $line | awk -F ":" '{print $2}')
        printf "%-60s %-60s\n" "$file" "$match"
      done <<< "$results"
    fi
    echo "---------------------------------------------------"
  done
done
