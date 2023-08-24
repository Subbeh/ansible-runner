#!/bin/bash

set -exuo pipefail

## Install Ansible inventory file.
mkdir -p /etc/ansible
echo -e "[local]\nlocalhost ansible_connection=local ansible_user=root" >/etc/ansible/hosts

## enable local ssh
ssh-keygen -A
mkdir -p -m 0600 /root/.ssh
echo "${DRONE_SSH_PUB_KEY}" >/root/.ssh/authorized_keys
echo -e "PasswordAuthentication no" >>/etc/ssh/sshd_config

## start sshd
/usr/sbin/sshd -D -e -f /etc/ssh/sshd_config &

## run script arguments
exec "$@"
