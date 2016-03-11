#!/bin/bash
osascript -e 'display notification "backup.sh is running" with title "Backup Started"' # Display notification that backup has started
cd /tmp
name=$(date "+%Y-%m-%d") # Get the ISO date

# Copy important files
mkdir $name
rsync --exclude '*.jpg' --exclude '*.jpeg' --exclude '*.png' --exclude '*.gif' --exclude '*.git' -a /Users/Z/Code $name
rsync -a /Users/Z/Dropbox/Apps/1Password /Users/Z/Dropbox/Apps/nvNotes /Users/Z/Dropbox/backups/Dad’s\ 1Password  /Users/Z/Dropbox/Certificates /Users/Z/Dropbox/Documents /Users/Z/Dropbox/School/McGill "$name/Dropbox"


tar -zcf "${name}.tar.gz" $name # Compress copied files
gpg -o "${name}.tar.gz.gpg" --sign --symmetric --cipher-algo AES256 --force-mdc "${name}.tar.gz" # Encrypt the compressed version

# Securely Remove the tmp files, twice because srm is dumb and fails sometimes
srm -rf $name
srm -f "${name}.tar.gz"
srm -rf $name
srm -f "${name}.tar.gz"

osascript -e 'display notification "All your files are safe!" with title "Backup Finished"' # backup finished notification