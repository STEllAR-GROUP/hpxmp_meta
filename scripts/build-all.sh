#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Get the directory of the currently executing script
DIR="$(dirname "$0")"

# Debugging output
echo "Running scripts from directory: $DIR"

# Run the individual build scripts, using the directory to find them
echo "Running build-hpx.sh"
bash "$DIR/build-hpx.sh" "$@"

echo "Running build-hpxc.sh"
bash "$DIR/build-hpxc.sh" "$@"

echo "Running build-hpxmp.sh"
bash "$DIR/build-hpxmp.sh" "$@"

echo "Running build-examples-hpxmp.sh"
bash "$DIR/build-examples-hpxmp.sh" "$@"
