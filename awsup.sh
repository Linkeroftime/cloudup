#!/bin/bash

LOG_DIRECTORY=~/logfiles/backup.log
mkdir -p ~/logfiles/

exec > >(tee -a "$LOG_DIRECTORY") 2>&1

log_date() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

if ! command -v rsync &> /dev/null; then
  echo "rsync is not installed. Please install using your respective package manager."
  exit 1
fi

if [[ $# -eq 0 ]]; then
 echo 'Usage: backup <file to backup>' 
 exit 2
fi

if [[ -z "$1" ]]; then
  echo 'Argument is null.'
  exit 3
fi


BACKUP_FILE="$1"
# username on remote system, usually root or your name
S3_BUCKET="your-s3-bucket-name"
S3_DIRECTORY="backup"

if aws s3 cp "$BACKUP_FILE" "s3://$S3_BUCKET/$S3_DIRECTORY/$(basename "$BACKUP_FILE")"; then
  log_date "Backup of $BACKUP_FILE was successful."
else
  log_date "Backup of $BACKUP_FILE failed. Check ~/logfiles/backup.log for details."
  exit 4
fi
