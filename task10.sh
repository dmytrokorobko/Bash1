#!/bin/bash

echo "Checking if the script is run as root..."
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

echo "Installing git..."
yum install git -y
if [ $? -ne 0 ]; then
    echo "Failed to install git."
    exit 1
fi

echo "Configuring git..."
echo "Checking git version..."
git --version
if [ $? -ne 0 ]; then
    echo "Git installation failed."
    exit 1
fi

echo "Setting up git user name..."
if [ -z "$(git config --global user.name)" ]; then
   echo "Setting git user name..."
   git config --global user.name "Dmytro Korobko"
   if [ $? -ne 0 ]; then
      echo "Failed to set git user name."
      exit 1
   fi
else
    echo "Git user name is already set."
fi


echo "Setting up git user email..."
if [ -z "$(git config --global user.email)" ]; then
   echo "Setting git user email..."
   git config --global user.email "dmytro.korobko@gmail.com"
   if [ $? -ne 0 ]; then
      echo "Failed to set git user email."
      exit 1
   fi
else
    echo "Git user email is already set."   
fi

echo "Setting default branch to main..."
git config --global init.defaultBranch main

echo "Checking if git is already initialized in the current directory..."
if [ ! -d ".git" ]; then
   echo "Initializing git repository in the current directory..."
   git init
   if [ $? -ne 0 ]; then
      echo "Failed to initialize git repository."
      exit 1
   fi
fi

echo "Adding all files to the staging area..."
git add .
if [ $? -ne 0 ]; then
    echo "Failed to add files to git repository."
    exit 1
fi

echo "Committing changes to the repository..."
date=$(date "+%Y-%m-%d %H:%M:%S")
git commit -m "$date: commit"
if [ $? -ne 0 ]; then
    echo "Failed to commit changes."
    exit 1
fi

echo "Checking if remote repository is set up..."
if ! git remote | grep -q origin; then
   git remote add origin "https://github.com/dmytrokorobko/Bash1.git"
fi

echo "Fetching changes from the remote repository..."
git pull origin main --allow-unrelated-histories --no-rebase

echo "Pushing changes to the remote repository..."
git push -u origin main
if [ $? -ne 0 ]; then
    echo "Failed to push changes to remote repository."
    exit 1
fi

echo "Git repository initialized and changes pushed successfully."
