#!/bin/bash

install_wordpress() {
    echo "Installing WordPress..."

    # Update and upgrade the system
    sudo apt update -y && sudo apt upgrade -y

    # Install necessary packages
    sudo apt install -y php7.4 php7.4-curl php7.4-gd php7.4-json php7.4-mbstring php7.4-xml libapache2-mod-php7.4 php7.4-mysql apache2 mysql-server phpmyadmin

    # Secure MySQL installation
    sudo mysql_secure_installation

    # Start and enable Apache and MySQL services
    sudo systemctl start apache2
    sudo systemctl enable apache2
    sudo systemctl start mysql
    sudo systemctl enable mysql

    # Download and extract WordPress
    wget https://wordpress.org/latest.zip -O /tmp/latest.zip
    sudo unzip /tmp/latest.zip -d /var/www/html/
    sudo mv /var/www/html/wordpress/* /var/www/html/
    sudo rm -rf /var/www/html/wordpress /tmp/latest.zip

    # Set permissions
    sudo chown -R www-data:www-data /var/www/html/
    sudo chmod -R 755 /var/www/html/

    # Create MySQL database and user for WordPress
    echo "Creating MySQL database and user for WordPress..."
    read -p "Enter a name for the WordPress database: " dbname
    read -p "Enter a username for the WordPress database: " dbuser
    read -s -p "Enter a password for the WordPress database user: " dbpass
    echo

    sudo mysql -u root -e "CREATE DATABASE ${dbname};"
    sudo mysql -u root -e "CREATE USER '${dbuser}'@'localhost' IDENTIFIED BY '${dbpass}';"
    sudo mysql -u root -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbuser}'@'localhost';"
    sudo mysql -u root -e "FLUSH PRIVILEGES;"

    # Create wp-config.php file
    echo "Creating wp-config.php file..."
    sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    sudo sed -i "s/database_name_here/${dbname}/" /var/www/html/wp-config.php
    sudo sed -i "s/username_here/${dbuser}/" /var/www/html/wp-config.php
    sudo sed -i "s/password_here/${dbpass}/" /var/www/html/wp-config.php

    # Set permissions for wp-config.php
    sudo chmod 640 /var/www/html/wp-config.php
    sudo chown www-data:www-data /var/www/html/wp-config.php

    echo "WordPress installation complete!"
    echo "You can access your WordPress site at http://your-server-ip/"
}

# Call the function to install WordPress
install_wordpress