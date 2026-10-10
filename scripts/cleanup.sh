#!/bin/bash

echo "--- CLEANUP ---"

if [ -f /tmp/command-lab-output.txt ]; then  # -f flag used to find out the folder via path . 
    rm /tmp/command-lab-output.txt
    echo "Temporary command output removed."
else
    echo "No temporary command output found."
fi
