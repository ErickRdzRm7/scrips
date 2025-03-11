#!/bin/bash

# ask for user input
read -p "user by remote server: " user
read -p "IP by hostname server: " host
read -p "path by remote: " remote_path

# definy local path
local_path="/var/www/html/index.html"

# send file to remote server
scp -r "$local_path" "$user@$host:$remote_path"

# exceute script in remote server
read -p "Excecute script in remote server (y/n): " run_script
if [[ "$run_script" == "y" ]]; then
    read -p "Server's Name: " script_name
    ssh "$user@$host" "cd $remote_path; chmod +x $script_name; ./$script_name"
fi

echo "All Done!"
