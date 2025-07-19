#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

echo "######################################################################"
echo "Starting task 6: Setting up a web server and downloading a web application."
echo "######################################################################"

echo "Checking if the server has a public IP address..."
ip addr show | grep "inet " | awk '{print $2}' | cut -d/ -f1

echo "Installing Apache HTTP Server and required packages..."
apt update
apt upgrade -y
apt install wget apache2 unzip -y
systemctl start apache2
systemctl enable apache2
systemctl status apache2 | grep "active (running)" &> /dev/null
if [ $? -eq 0 ]; then
    echo "Apache HTTP Server is installed and running."
else
    echo "Failed to start Apache HTTP Server."
    exit 1
fi 

# Download the latest version of the web application
url="https://www.tooplate.com/zip-templates/2129_crispy_kitchen.zip"
tempDir="/opt/temp"
themeName=$(echo $url | awk -F/ '{print $NF}' | sed 's/.zip//')
if [ -z "$themeName" ]; then
    echo "Failed to extract theme name from URL."
    exit 1
fi
echo "Theme name: $themeName"

echo "Creating temporary directory $tempDir..."
mkdir -p "$tempDir"
if [ $? -ne 0 ]; then
    echo "Failed to create temporary directory $tempDir."
    exit 1
fi
if [ "$(ls -A "$tempDir")" ]; then
   echo "Temporary directory $tempDir is not empty. Cleaning..."
   rm -rf "$tempDir"/*
fi

echo "Downloading the web application from $url..."
wget -q "$url" -O "$tempDir"/"webapp.zip"
if [ $? -ne 0 ]; then
    echo "Failed to download the web application."
    exit 1
fi

echo "Unzipping the web application..."
unzip -q "$tempDir"/"webapp.zip" -d "$tempDir"
if [ $? -ne 0 ]; then
    echo "Failed to unzip the web application."
    exit 1
fi 

echo "Clearing the /var/www/html/ directory..."
rm -rf /var/www/html/*
if [ $? -ne 0 ]; then
    echo "Failed to clear the /var/www/html/ directory."
    exit 1
fi

echo "Moving web application files to /var/www/html/..."
mv -f "$tempDir/$themeName"/* /var/www/html/
if [ $? -ne 0 ]; then
    echo "Failed to move web application files to /var/www/html/."
    exit 1
fi

echo "Cleaning up temporary files..."
rm -rf "$tempDir"

echo "Web application downloaded and extracted to /var/www/html/."
systemctl restart apache2
