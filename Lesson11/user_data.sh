#!/bin/bash
apt -y update
apt -y install nginx
echo "<h2>WebServer is Working!</h2><br>Build by Terraform!" > /var/www/html/index.html
echo "<br> add more test text v2" >> /var/www/html/index.html
sudo systemctl start nginx
sudo systemctl  enable nginx