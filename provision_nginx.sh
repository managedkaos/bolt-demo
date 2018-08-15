# Update the package references
apt-get update

# Uninstall apache2
systemctl stop apache2 || true
apt-get -y remove apache2

# Install nginx
apt-get -y install nginx

# Restart
systemctl restart nginx
