#!/bin/bash

disk=$1
if [ -z "$disk" ]; then
    echo "Usage: $0 <disk>"
    exit 1
fi

usedSpace=$(df -h | grep "$disk" | awk '{print $5}' | sed 's/%//')
if (( usedSpace > 39 )); then
    echo "Disk usage on $disk is above 39%: $usedSpace%"
    echo "Consider cleaning up some files."
    if [ ! -d "/opt/alerts" ]; then
        sudo mkdir -p /opt/alerts
    fi
    if [ ! -f /opt/alerts/disk_alert.txt ]; then
        touch /opt/alerts/disk_alert.txt
    fi
    echo "Disk usage alert for $disk: $usedSpace%" | sudo tee -a /opt/alerts/disk_alert.txt
    echo "Alert logged in /opt/alerts/disk_alert.txt"
else
    echo "Disk usage on $disk is within limits: $usedSpace%"
fi