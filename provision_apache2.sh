# Update the package references
apt-get update

# Uninstall nginx
systemctl stop nginx
apt-get -y remove nginx

# Install apache2
apt-get -y install apache2

# Restart
systemctl restart apache2
