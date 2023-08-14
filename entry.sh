#!/bin/bash

set -euo pipefail

## Install Ansible inventory file.
mkdir -p /etc/ansible
echo -e "[local]\nlocalhost ansible_connection=local ansible_user=root" >/etc/ansible/hosts

ssh-keygen -A
echo -e "PasswordAuthentication no" >>/etc/ssh/sshd_config
mkdir -p -m 0600 /root/.ssh
cp /etc/ssh/ssh_host_rsa_key.pub /root/.ssh/authorized_keys
eval $(ssh-agent -s)
ssh-add /etc/ssh/ssh_host_rsa_key

/usr/sbin/sshd -D -e -f /etc/ssh/sshd_config &
exec "$@"
