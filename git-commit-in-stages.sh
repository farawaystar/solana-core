#!/bin/bash

# Get the input alphabet
echo "Enter the alphabet to stop at (a-z):"
read stop_alphabet

# Get list of folders, sorted alphabetically
folders=$(find . -maxdepth 1 -type d | sort)

# Initialize a flag to check if we've reached the stop alphabet
reached_stop=false

for folder in $folders; do
    folder_name=$(basename "$folder")
    first_letter=${folder_name:0:1}
    
    # Convert to lowercase for comparison
    first_letter_lower=$(echo "$first_letter" | tr '[:upper:]' '[:lower:]')
    
    # Stop if we've reached or passed the stop alphabet
    if [[ "$first_letter_lower" > "$stop_alphabet" || "$first_letter_lower" == "$stop_alphabet" ]]; then
        reached_stop=true
        break
    fi
    
    # Stage the folder
    git add "$folder"
    echo "Staged: $folder"
done

# Commit and push if any folders were staged
if [ "$reached_stop" = true ]; then
    git commit -m "Add folders up to $stop_alphabet"
    git push origin master
    echo "Committed and pushed folders up to $stop_alphabet"
else
    echo "No folders to commit up to $stop_alphabet"
fi
