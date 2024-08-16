#!/bin/bash

# Get a list of all .txt files in the current directory
txt_files=(*.txt)

# Check if there are any .txt files
if [ ${#txt_files[@]} -eq 0 ]; then
  echo "No .txt files found in the current directory."
  exit 1
fi

# Ensure there is more than one file to intersect
if [ ${#txt_files[@]} -eq 1 ]; then
  echo "At least two .txt files are required to compute the intersection."
  exit 1
fi

# Create a temporary file for storing intermediate results
temp_file=$(mktemp)

# Initialize the intersection with the content of the first file
cp "${txt_files[0]}" "$temp_file"

# Iterate through the remaining .txt files
for file in "${txt_files[@]:1}"; do
  # Find the intersection with the current file
  grep -Fxf "$temp_file" "$file" > "$temp_file.tmp"
  mv "$temp_file.tmp" "$temp_file"
done

# Create the output filename based on the .txt files
output_file=$(printf "%s" "${txt_files[@]}" | sed 's/\.txt/+/g' | sed 's/+$//').txt

# Move the final result to the output file
mv "$temp_file" "$output_file"

# Check if the output file is empty and provide appropriate feedback
if [ -s "$output_file" ]; then
  echo "Intersection of URLs saved to $output_file"
else
  echo "No common URLs found."
  rm "$output_file" # Remove empty file
fi
