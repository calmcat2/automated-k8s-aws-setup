#!/bin/bash

echo "Starting user data script..."

# echo "adding local machine's public key to authrized_keys"
# cat >> /home/ubuntu/.ssh/authorized_keys << EOF
# ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+kK2iaKJDhcQ9RCkQUgtxlE6wc25d91hL1J189ffoOWcZjL6MhbfDR/NkMR62QXK3EDpI/Ev3C5jPOs6DLWJ+8rFYRsfuWEHIrQljxuwaZllni1Ws5NkOjbau39z8/IaYqAPT/jE3ZmRblKOHpXpp/r+E2SuomkIQKODEITkp2VheTJ551kq8JE9fSTi+QTrKzUY/xuKYlezmQiVCpjc0Q4wybJBxsRBqC9S1c9ugpcKC3ciP2cxqUchliFYeyF82CTfXof0FWxVLe1Xg497XaGjbn5mVRlBbTN1JJgZR1u1W7Zm+28FZpLkgx/2sday4B6Lmk9+Nt/w/VPN9VASt rsa-key-20241026
# EOF
# cat /home/ubuntu/.ssh/authorized_keys

# echo "Generating ssh key pairs..."
# ssh-keygen -t rsa -b 4096 -N "" -f /home/ubuntu/.ssh/ansible_control_key -q
# chown ubuntu:ubuntu /home/ubuntu/.ssh/ansible_control_key.pub
# chmod 700 /home/ubuntu/.ssh/ansible_control_key.pub
# cat /home/ubuntu/.ssh/ansible_control_key.pub

echo "Updating the system..."
sudo apt update -y

echo "Installing software-properties-common..."
sudo apt install software-properties-common -y

# Add Ansible PPA and install Ansible
echo "Adding Ansible PPA..."
sudo add-apt-repository --yes --update ppa:ansible/ansible
echo "Installing Ansible..."
sudo apt install ansible -y

# Verify installation
echo "Verifying Ansible installation..."
ansible --version

# # Create an inventory file (optional)
# echo "Creating Ansible inventory file..."
# mkdir -p /etc/ansible
# cat <<EOL > /etc/ansible/hosts
# [local]
# localhost ansible_connection=local
# EOL

echo "User data script completed successfully."