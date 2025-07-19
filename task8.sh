#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

while true; do
   echo "Select option:"
   echo "1. View Memory usage"
   echo "2. View disk usage"
   echo "3. Exit"
   read -p "Enter your choice: " choice

   case "$choice" in
      1) 
         echo "######################################################################"
         echo "Memory usage:"
         echo "######################################################################"
         free -h
         ;;
      2) 
         echo "You selected disk usage." 
         echo "######################################################################"
         echo "Disk usage:"
         echo "######################################################################"
         df -h
         ;;
      3) 
         echo "Exiting..." ; exit 0 
         ;;
      *) 
         echo "Invalid choice. Please try again." 
         continue
         ;;
   esac   
   echo
done