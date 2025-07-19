#!/bin/bash

file=$1
if [ -z "$file" ]; then
    echo "Usage: $0 <file>"
    exit 1
fi 

for username in $(cat "$file"); do
    if id "$username" &>/dev/null; then
        echo "User $username exists."
    else
        echo "User $username does not exist. Creating user..."
        sudo useradd "$username"
        if [ $? -eq 0 ]; then
            echo "User $username created successfully."
        else
            echo "Failed to create user $username."
        fi
    fi
done