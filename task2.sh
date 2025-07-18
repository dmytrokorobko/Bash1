#!/bin/bash

# This script checks if the selected service is installed and running.
SERVICE=$1
if [ -z "$SERVICE" ]; then
   echo "Usage: $0 <service_name>"
   exit 1
fi

#check if active user is root
check_root() {
   if [ "$(id -u)" -ne 0 ]; then
      echo "This script must be run as root. Please use sudo."
      exit 1
   fi
}

#Check if httpd is installed
# and running, if not, install and start it
check_service_installed() {
   if ! command -v $SERVICE &> /dev/null; then
      echo "$SERVICE is not installed. Installing $SERVICE..."
      yum install -y $SERVICE 1>/dev/null
   fi
}

check_service_active() {
   serviceStatus=$(systemctl status $SERVICE | grep Active | awk '{print $2}')
   if [ $serviceStatus != "active" ]; then
      echo "$SERVICE isn't active...Restarting $SERVICE service"
      systemctl start $SERVICE
      if [ $? -eq 0 ]; then
         echo "$SERVICE service started successfully"
      else
         echo "Failed to start $SERVICE service"
      fi
   else
      echo "$SERVICE is already running"
   fi
}

#Main function
main() {
   check_root
   check_service_installed
   check_service_active
}

# Run the main function
main
exit 0
# End of script
