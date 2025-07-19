#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

if [ ! -f "/opt/memlog.txt" ]; then
    echo "Memory log file does not exist. Creating it now."
    touch /opt/memlog.txt
fi

mem=$(free -m | awk '/Mem:/ { print "Used: "$3"MB, Free: "$4"MB" }')
date=$(date "+%Y-%m-%d %H:%M:%S")
echo "$date: Memory: $mem" >> /opt/memlog.txt
if [ $? -ne 0 ]; then
    echo "Failed to log memory usage."
    exit 1
fi
echo "Memory usage logged to /opt/memlog.txt"