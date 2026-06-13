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
    exit 1
fi

# Copying the assets.csv file to the Helpers directory

echo 'Email,Names,Attendance Count,Absence Count
alice@example.com,Alice Johnson,14,1
bob@example.com,Bob Smith,7,8
charlie@example.com,Charlie Davis,4,11
diana@example.com,Diana Prince,15,0
' > "$directory_name/Helpers/assets.csv"

if [ -f "$directory_name/Helpers/assets.csv" ]; then
    echo "Verification successful: assets.csv is present."
   

else
    echo "Error: assets.csv missing."
    exit 1
fi

# Copying the config.json file to the Helpers directory

echo '{
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "live",
    "total_sessions": 15
}
' > "$directory_name/Helpers/config.json"

if [ -f "$directory_name/Helpers/config.json" ]; then
    echo "Verification successful: config.json is present."
else
    echo "Error: config.json missing."
    exit 1
fi

# Copying the expected reports.log output to the reports directory

echo '--- Attendance Report Run: 2026-02-06 18:10:01.468726 ---
[2026-02-06 18:10:01.469363] ALERT SENT TO bob@example.com: URGENT: Bob Smith, your attendance is 46.7%. You will fail this class.
[2026-02-06 18:10:01.469424] ALERT SENT TO charlie@example.com: URGENT: Charlie Davis, your attendance is 26.7%. You will fail this class.
' > "$directory_name/reports/reports.log"

if [ -f "$directory_name/reports/reports.log" ]; then
    echo "Verification successful: reports.log is present."
    
else
    echo "Error: reports.log missing."
    exit 1
fi

# Now I'm going to ask the user if they want to update the attendance thresholds in the config file

read -r -p "You want to update the attendance thresholds?[Y/N]: " choice

case "$choice" in
  [Yy]*)
    read -r -p "Enter warning threshold(default 75%): " warning
    warning=${warning:-75}
    warning=${warning%[%]*}
    read -r -p "Enter failure threshold(default 50%): " failure
    failure=${failure:-50}
    failure=${failure%[%]*}

    if [[ "$warning" =~ ^[0-9]+$ && "$failure" =~ ^[0-9]+$ ]]; then

      sed -i "s/75/$warning/g" "$directory_name/Helpers/config.json"
      sed -i "s/50/$failure/g" "$directory_name/Helpers/config.json"

      echo "Threshold updated successfully to $warning% and $failure%"
    else
      echo "Error: Thresholds must be numeric values. Update aborted."

    fi
    

    ;;
  [Nn]*)
      echo "Keeping default thresholds (75% and 50%)"
    ;;
    *)
      echo "Invalid input skipping updates..."
      exit 1
esac