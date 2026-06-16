I. Attendance Tracker Setup

This repository contains a shell script to create a simple student attendance tracker project structure.

II. What it does

- Checks if python3 is installed
- Creates a project directory named attendance_tracker_<identifier>
- Generates:
  - attendance_checker.py
  - Helpers/assets.csv
  - Helpers/config.json
  - reports/reports.log
- Optionally updates attendance threshold values in Helpers/config.json
- Archives the project directory if interrupted by SIGINT

III. Usage

  i.Running

1. Run the setup script: "bash setup_project.sh" or "./setup_project.sh"
2. Enter a unique identifier when prompted.
3. Answer "Y" or "N" when asked whether to update attendance thresholds.
4. If "Y", provide values for the warning and failure thresholds.
 
  ii.Interruption
1. Press ctrl+c to signal the code from running

IV. Notes

- The script expects python3 to be installed.
- The project directory created is attendance_tracker_<identifier>.
- If the script receives an interrupt signal, it archives the directory.

V. Video 

Here is a link to the video that explains the structure and how the code works

https://drive.google.com/file/d/133ytJPAplk9MIWAe8F1IeYEdIkCuTrCG/view?usp=sharing