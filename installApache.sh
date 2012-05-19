#!/bin/sh
#	file: installApache.sh
#	author: technocake
#	desc: Installs apache2 with php5 mysql and copies backupconfig + www files on pompel
#	date: 05.05.2011 15:42
###########################################################################################
echo "Installing apache mit php5 mit mysql" 
sudo apt-get install apache2 mysql5-common mysql-server mysql-client php5 libphp5-mod-mysql libapache2-mod-php5

echo "Installing phpmyadmin" 
sudo apt-get install libapache2-mod-auth-mysql php5-mysql phpmyadmin

echo "Slår på mysql i php.ini"
sed -i 's/;extension=mysql.so/extension=mysql.so/i' /etc/php5/apache2/php.ini

echo "Fetching all configs from backup"
#--preserve keeps file rights etc
cp -rv --preserve /root/pompel-backup/etc/apache2 /etc/

echo "Fetching all /var/www files from backup"
cp -rv --preserve /root/pompel-backup/var/www /var/



echo "Starter apache på nytttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt"

apache2ctl graceful


