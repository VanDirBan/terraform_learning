#!/bin/bash
apt -y update
apt -y install nginx
echo "<h2>WebServer is Working!</h2><br>Build by Terraform! <br> " > /var/www/html/index.html

cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Terraform</h2><br>
Owner = ${f_name} <br>
Thanks to
%{ for x in names ~}
 ${x},
%{ endfor ~}
</html>
EOF

sudo systemctl start nginx
sudo systemctl  enable nginx