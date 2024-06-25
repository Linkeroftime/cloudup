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


SSH_KEYPAIR="/path/to/keypair.pem"
BACKUP_FILE="$1"
# username on remote system, usually root or your name
REMOTE_USER="root"
BACKUP_MACHINE="public.ip.of.remote.machine"
BACKUP_DIRECTORY="~/backup"


if rsync -avz -e "ssh -i $SSH_KEYPAIR" "$BACKUP_FILE" $REMOTE_USER@$BACKUP_MACHINE:$BACKUP_DIRECTORY; then
  log_date "Backup of $BACKUP_FILE was successful."
else
  log_date "Backup of $BACKUP_FILE failed. Check ~/logfiles/backup.log for details."
  exit 4
fi
