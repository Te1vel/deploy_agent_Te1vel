#!/usr/bin/env bash

#i'm going to start of by creating the main directory and sub directories
echo "Creating project directory structure"
echo "......................................."
read -r -p "Enter project name identifier: " version

directory_name="attendance_tracker_$version"

mkdir -p "$directory_name"/{Helpers,reports}

if [ -d "$directory_name" ]; then
    echo "Directory $directory_name created successfully"
else
    echo "ERROR: Directory creation failed"
    exit 1
fi
