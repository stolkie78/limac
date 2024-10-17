#/bin/bash
sudo apt install curl unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/install/awscliv2.zip"
unzip /tmp/install/awscliv2.zip
sudo ./aws/install