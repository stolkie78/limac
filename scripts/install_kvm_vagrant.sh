#!/bin/bash

# Script to install KVM and Vagrant on Ubuntu

# Update package lists
echo "Updating package lists..."
sudo apt update

# Check if the CPU supports hardware virtualization
echo "Checking for hardware virtualization support..."
egrep -c '(vmx|svm)' /proc/cpuinfo
if [ $? -eq 0 ]; then
    echo "Hardware virtualization is supported."
else
    echo "Error: Hardware virtualization is not supported on this machine."
    exit 1
fi

# Install KVM and related packages
echo "Installing KVM and related tools..."
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager virtinst

# Check the status of libvirtd service
echo "Checking libvirt service status..."
sudo systemctl enable --now libvirtd

# Add current user to libvirt group
echo "Adding $(whoami) to libvirt group..."
sudo usermod -aG libvirt $(whoami)
newgrp libvirt

# Install Vagrant
echo "Installing Vagrant..."
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && apt install -y vagrant
sudo apt update && apt install -y  ruby-libvirt libvirt-daemon-system libvirt-clients ebtables dnsmasq-base libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev libguestfs-tools libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev libguestfs-tools build-essential

# Verify Vagrant installation
echo "Vagrant version:"
vagrant --version

# Install the Vagrant-libvirt plugin
echo "Installing vagrant-libvirt plugin..."
vagrant plugin install vagrant-libvirt



# Verify Vagrant plugin installation
echo "Installed Vagrant plugins:"
vagrant plugin list

echo "Installation complete. Please log out and log back in to apply group changes."

