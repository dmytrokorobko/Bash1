#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: $0 <server_list_file>"
    exit 1
fi

servers=$(cat $1)
if [ -z "$servers" ]; then
    echo "No servers found in $1 file"
    exit 1
fi

for server in $servers; do
   echo "Processing server: $server"
   hostExist=$(getent hosts "$server" &> /dev/null)
   if [ $? -ne 0 ]; then
      echo "Server $server does not exist in the DNS."
      continue
   fi
   echo "Server $server exists in the DNS."

   echo "Checking access to server $server..."
   permit=$(ssh -o BatchMode=yes -o ConnectTimeout=3 vagrant@"$server" "echo ok" 2>/dev/null)
   if [ $? -ne 0 ]; then
      echo "Failed to connect to server $server with SSH access."
      echo "Copying the public key to the server..."
      ssh-copy-id -o BatchMode=no -o ConnectTimeout=3 vagrant@"$server" &> /dev/null
      if [ $? -ne 0 ]; then
         echo "Failed to copy the public key to server $server."
         continue
      fi      
   fi

   ipaddr=$(ssh vagrant@"$server" "ip addr show | grep 192.168 | awk '{print $2}' | cut -d/ -f1") 
   if [ -z "$ipaddr" ]; then
      echo "Failed to retrieve IP address for server $server."
      continue
   fi

   uptime=$(ssh vagrant@"$server" "uptime -p")   
   if [ $? -ne 0 ]; then
      echo "Failed to retrieve uptime for server $server."
      continue
   fi
   echo "#######################################################################"
   echo "$ipaddr: $uptime"
   echo "#######################################################################"
done