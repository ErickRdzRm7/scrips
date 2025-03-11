#!/bin/bash

#create linux files backup
backup_files() {
    echo "Creating a backup of files..."
   sudo tar -cvpzf ~/backup.tar.gz --exclude=/home/xlegend_6661/backupfile.tar.gz --one-file-system /
    echo "Backup of files completed!"
} 

send_backup(){
    #sending via rsync
    echo "Sending backup to remote server..."
     rsync -av --progress  ssh ~/home/xlegend_6661 34.72.13.79:~/xlegend_6661
    echo "Backup sent to remote server!"        
    
}