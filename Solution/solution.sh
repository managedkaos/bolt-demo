#!/bin/bash -xe
printf '%.0s#' {1..50}; echo
echo -n "# Checking bolt installation: "
which bolt ||
    (echo "Couldn't find bolt! Is it installed?" && return 1)

printf '%.0s#' {1..50}; echo
echo -n "# Checking bolt version: "
bolt --version ||
    (echo "Coudln't find bolt! Is it installed?" && return 2)

printf '%.0s#' {1..50}; echo
echo "## Run bolt on one node with user and password for auth"
set -x
bolt --user vagrant \
     --password vagrant \
     --nodes 192.168.56.101 \
     --no-host-key-check \
     command run hostnamectl
set +x
printf '%.0s#' {1..50}; echo
echo

printf '%.0s#' {1..50}; echo
echo "## Run bolt on all nodes with user and  password for auth"
set -x
bolt --user vagrant \
     --password vagrant \
     --nodes 192.168.56.101,192.168.56.102,192.168.56.103 \
     --no-host-key-check \
     command run 'hostnamectl'
set +x
printf '%.0s#' {1..50}; echo
echo

printf '%.0s#' {1..50}; echo
echo "## Create SSH keys and inject them into the nodes"
source Solution/make_ssh_key.sh
printf '%.0s#' {1..50}; echo
echo

printf '%.0s#' {1..50}; echo
echo "## Run bolt on all nodes using the SSH key for auth"
set -x
bolt --private-key ./vagrant.key \
     --user vagrant \
     --nodes 192.168.56.101,192.168.56.102,192.168.56.103 \
     --no-host-key-check \
     command run uptime
set +x
printf '%.0s#' {1..50}; echo
echo

printf '%.0s#' {1..50}; echo
echo "## Run bolt with all config in an inventory file"
set -x
bolt --inventoryfile ./inventory.yml \
     --nodes webservers \
     command run hostnamectl
set +x
printf '%.0s#' {1..50}; echo
echo

printf '%.0s#' {1..50}; echo
echo "## Check the output of the web server for Apache"
set -x
curl -s http://192.168.56.101 | grep "<title>" | grep -i apache
set +x
printf '%.0s#' {1..50}; echo
echo

printf '%.0s#' {1..50}; echo
echo "## Uninstall Apache and install NGINX"
set -x
bolt --run-as root \
     --inventoryfile ./inventory.yml \
     --nodes webservers \
     script run provision_nginx.sh
set +x
printf '%.0s#' {1..50}; echo
echo

printf '%.0s#' {1..50}; echo
echo "## Check the output of the web server for NGINX using HTTPS"
set -x
curl -s -L -k https://192.168.56.101 | grep "<title>" | grep -i nginx
set +x
printf '%.0s#' {1..50}; echo
echo

printf '%.0s#' {1..50}; echo
echo "## Upload the NGINX config File"
set -x
bolt --run-as root \
     --inventoryfile ./inventory.yml \
     --nodes webservers \
     file upload nginx.conf /etc/nginx/sites-available/default
set +x
printf '%.0s#' {1..50}; echo
echo

printf '%.0s#' {1..50}; echo
echo "## Reload NGINX to apply the new config"
set -x
bolt --run-as root \
     --inventoryfile ./inventory.yml \
     --nodes webservers \
     command run "systemctl reload nginx"
set +x
printf '%.0s#' {1..50}; echo
echo

printf '%.0s#' {1..50}; echo
echo "## Check the output of the web server for NGINX using HTTPS"
set -x
curl -s -L -k https://192.168.56.101 | grep "<title>" | grep -i nginx
set +x
printf '%.0s#' {1..50}; echo
echo

printf '%.0s#' {1..50}; echo
echo "## Remove the Apache index file"
set -x
bolt --run-as root \
     --inventoryfile ./inventory.yml \
     --nodes webservers \
     command run "rm -vf /var/www/html/index.html"
set +x
printf '%.0s#' {1..50}; echo
echo

printf '%.0s#' {1..50}; echo
echo "## Check the output of the web server for NGINX using HTTPS"
set -x
curl -s -L -k https://192.168.56.101 | grep "<title>" | grep -i nginx
set +x
printf '%.0s#' {1..50}; echo
echo