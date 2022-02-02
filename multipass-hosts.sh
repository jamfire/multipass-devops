#!/bin/bash

# output colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

# Add Multipass VM's to /etc/hosts using domain.local format
# For example add 192.168.64.1 wordpress.local

# enter privileged mode in order to write to /etc/hosts
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

printf "${BLUE}[multipass]${NC} update /etc/hosts with multipass virtual machines\n"

# hosts file
file=/etc/hosts

# delimiters
hstart="### start multipass routing ###"
hend="### end multipass routing ###"

# looking for multipass routing and clean if found
if grep -q "${hstart}" "$file"; then
    sed -i '' "/$hstart/,/$hend/d" $file
fi

# add opening delimiter
echo -e "${hstart}\n" >> /etc/hosts

# add running vms to hosts file with .local domain
multipass list --format json | jq -c -r '.list[] | select(.state=="Running")' | while read i; do
    ip="$(echo $i | jq -c -r '.ipv4[0]') "
    domain="$(echo $i | jq -c -r '.name').local"
    host="${ip}${domain}"
    echo -e "$host" >> /etc/hosts
    printf "${GREEN}${ip}${NC}${domain}\n"
done

# add closing delimiter
echo -e "\n${hend}" >> /etc/hosts
