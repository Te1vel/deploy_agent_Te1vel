#!/usr/bin/env bash

# I'm going to start of by creating the main directory and sub directories
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

# Copying the attendance_checker.py codes to my shellscript

echo 'import csv
import json
import os
from datetime import datetime

def run_attendance_check():
    # 1. Load Config
    with open('Helpers/config.json', 'r') as f:
        config = json.load(f)
    
    # 2. Archive old reports.log if it exists
    if os.path.exists('reports/reports.log'):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        os.rename('reports/reports.log', f'reports/reports_{timestamp}.log.archive')

    # 3. Process Data
    with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log', 'w') as log:
        reader = csv.DictReader(f)
        total_sessions = config['total_sessions']
        
        log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")
        
        for row in reader:
            name = row['Names']
            email = row['Email']
            attended = int(row['Attendance Count'])
            
            # Simple Math: (Attended / Total) * 100
            attendance_pct = (attended / total_sessions) * 100
            
            message = ""
            if attendance_pct < config['thresholds']['failure']:
                message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}%. You will fail this class."
            elif attendance_pct < config['thresholds']['warning']:
                message = f"WARNING: {name}, your attendance is {attendance_pct:.1f}%. Please be careful."
            
            if message:
                if config['run_mode'] == "live":
                    log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}\n")
                    print(f"Logged alert for {name}")
                else:
                    print(f"[DRY RUN] Email to {email}: {message}")

if __name__ == "__main__":
    run_attendance_check()' > "$directory_name/attendance_checker.py"

# Verifying the existence of attendance_checker.py

if [ -f "$directory_name/attendance_checker.py" ]; then
    echo "Verification successful: attendance_checker.py is present."
else
    echo "Error: attendance_checker.py missing."
fi
