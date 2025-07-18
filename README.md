# Bash1 – DevOps Bash Script Collection

This repository contains a series of Bash automation tasks completed as part of my DevOps training. Each script solves a common system administration challenge and demonstrates foundational skills in Linux, cron, SSH, user management, Git, and monitoring.

## 📁 Task List

### 1. Backup Script
Backs up the `/var/log` directory into a compressed archive under `/opt/backups` with a timestamped filename.

### 2. Service Health Checker
Checks the status of a given service and restarts it if inactive.

### 3. Disk Space Alert
Monitors disk usage and writes an alert to `/opt/alerts/disk_alert.txt` if usage exceeds 80%.

### 4. Batch User Creator
Reads usernames from a file and creates them using `useradd`.

### 5. Log Cleaner
Deletes `.log` files older than 7 days from `/var/log`.

### 6. Apache Deployer Script
Installs Apache (`httpd`) and deploys a static website to `/var/www/html`.

### 7. Array Loop Report
Iterates over an array of remote servers and collects their uptime via SSH.

### 8. Interactive Menu
Displays a terminal menu with three options: memory usage, disk usage, and exit.

### 9. Crontab Creator
Logs available memory to `/opt/memlog.txt` and sets up a cron job to repeat every 15 minutes.

### 10. Git Auto-Commit Script
Adds all changes, commits them with a timestamp, and pushes to the `main` branch on GitHub.

---

## 🚀 Usage

All scripts are tested on CentOS 7-based systems with root access.  
To run a script:

```bash
sudo bash task1.sh


## 🧑‍💻 Author
Dmytro Korobko
DevOps Student & Automation Enthusiast
GitHub: @dmytrokorobko

## 📜 License
MIT — use these scripts freely for learning or adaptation.
