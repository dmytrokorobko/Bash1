#!/bin/bash

# This script checks for log files older than a specified number of days and deletes them
# Usage: ./task5.sh <days>

# Redirect output to a log file
exec &>> /var/log/log_cleaner_output.log

# This script deletes log files older than a specified number of days
days=$1
if [ -z "$days" ]; then
    echo "Usage: $0 <days>"
    exit 1
fi

# Validate that the input is a positive integer
if ! [[ "$days" =~ ^[0-9]+$ ]]; then
    echo "Error: Days must be a positive integer."
    exit 1
fi

# Check if the logs folder exists
logsFolder=/var/log
if [ ! -d "$logsFolder" ]; then
    echo "Logs folder does not exist."
    exit 1
fi 

echo "######################################################################"
echo "Starting log file cleanup process for files older than $days days."
echo "######################################################################"

# Iterate through log files in the logs folder
for logFile in $(ls "$logsFolder"); do
   if [ -f "$logsFolder"/"$logFile" ]; then
      echo "Checking log file: $logFile"
      fileLastDate=$(stat -c %Y "$logsFolder"/"$logFile")
      currentDate=$(date +%s)
      diff=$((($currentDate - $fileLastDate) / 86400)) # Calculate difference in days
      if [ $diff -gt $days ]; then
         echo "Log file $logFile is older than $days days. Deleting..."
         sudo rm "$logsFolder"/"$logFile"
         if [ $? -eq 0 ]; then
            echo "Log file $logFile deleted successfully."
         else
            echo "Failed to delete log file $logFile."
         fi
      else
         echo "Log file $logFile is not older than $days days. No action taken."
      fi
   else
      echo "$logFile is not a file."
   fi
done