#!/bin/sh

# Update manifest script
#
# this script takes flathub project's yaml as argument
# adds #END current-date at the bottom of the file if it does't exists
# if it exists it updates date with current date.
#
# the primary usecase of this script is to cause a change on the passed
# project manifest file

# Trim trailing spaces from the argument
REPO_CLEAN_PATH=$(echo "$1" | sed 's/[[:space:]]*$//')

# Get today's date
TODAY=$(date +"%Y-%m-%d")

# Check if the last line starts with '#END'
if tail -n1 "$REPO_CLEAN_PATH" | grep -q '^#END'; then
    # Replace last line with '#END' followed by today's date
    sed -i '$s/^#END.*$/#END '"$TODAY"'/' "$REPO_CLEAN_PATH"
else
    # Add last line with '#END' followed by today's date
    echo "#END $TODAY" >> "$REPO_CLEAN_PATH"
fi
