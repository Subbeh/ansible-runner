#!/bin/bash

set -exuo pipefail

## Set up Ansible environment
git config --global --add safe.directory /drone/src
echo "${ANSIBLE_VAULT_PASSWORD:?not set}" >$HOME/.ansible_vault

mkdir -p /etc/ansible
echo -e "[local]\nlocalhost ansible_connection=local ansible_user=root" >/etc/ansible/hosts

## enable local ssh
ssh-keygen -A
mkdir -p /root/.ssh
echo "${DRONE_SSH_KEY}" >/root/.ssh/id_ed25519
echo "${DRONE_SSH_PUB_KEY}" >/root/.ssh/authorized_keys
chmod -R 600 /root/.ssh
echo -e "PasswordAuthentication no" >>/etc/ssh/sshd_config

## start sshd
/usr/sbin/sshd -D -e -f /etc/ssh/sshd_config &

## run script arguments
exec "$@"
