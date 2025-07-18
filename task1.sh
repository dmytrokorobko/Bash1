#!/bin/bash

# Create backup all log files in /var/log
# and save them to /opt/scripts/logs_backup
# The script should be run as root

#Variables
BACKUP_DIR="/opt/scripts/logs_backup"
LOG_DIR="/var/log"

# Create backup directory if it does not exist
# and create a temporary directory inside it
create_directories() {
   if [ ! -d "$BACKUP_DIR" ]; then
      echo "Creating backup directory at $BACKUP_DIR"
      sudo mkdir -p "$BACKUP_DIR"
   fi

   if [ ! -d "$BACKUP_DIR/tmp" ]; then
      echo "Creating temporary directory at $BACKUP_DIR/tmp"
      sudo mkdir -p "$BACKUP_DIR/tmp"
   fi
}

# Copy log files into temp folder
copy_logs() {
   for log in $(ls "$LOG_DIR")
   do   
      if [ -f "$LOG_DIR/$log" ]; then
         if [ $(stat -c%s "$LOG_DIR/$log") -gt 0 ]; then
            sudo cp $LOG_DIR/$log "$BACKUP_DIR/tmp/$log"
            echo "Backup of $log created in $BACKUP_DIR"         
         fi
      else
         echo "Skipping $log, not a file"
         continue
      fi
   done
}

# Compress the backup directory
compress_backup() {
   if [ ! "$(ls -A "$BACKUP_DIR/tmp")" ]; then
      echo "No files to backup"
      exit 1
   fi

   tar -czf "$BACKUP_DIR/log_$(date +%F).tar.gz" -C "$BACKUP_DIR/tmp/" "."
   echo "Backup completed successfully. All logs are saved in $BACKUP_DIR/log_$(date +%F).tar.gz"

   sudo rm -rf "$BACKUP_DIR/tmp"
   echo "Temporary files removed from $BACKUP_DIR/tmp"
}

# Main function
main() {
   create_directories
   copy_logs
   compress_backup   
}

# Run the main function
if [ "$(id -u)" -ne 0 ]; then
   echo "This script must be run as root. Please use sudo."
   exit 1
fi

main
exit 0
# End of script

