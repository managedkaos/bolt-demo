# Update the package references
apt-get update

# Install nginx
apt-get -y install nginx

# Restart
systemctl restart nginx
