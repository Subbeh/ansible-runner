FROM alpine/ansible:latest

ARG GIT_USER
ARG GIT_PASSWORD

## install base packages
RUN apk add build-base git grep curl openssh

## fetch requirements files
ADD https://$GIT_USER:$GIT_PASSWORD@git.sbbh.cloud/sysadm/homelab/raw/branch/main/ansible/requirements.txt /tmp/requirements.txt
ADD https://$GIT_USER:$GIT_PASSWORD@git.sbbh.cloud/sysadm/homelab/raw/branch/main/ansible/requirements.yml /tmp/requirements.yml

## install Ansible dependencies
RUN pip install -r /tmp/requirements.txt
RUN ansible-galaxy install -r /tmp/requirements.yml --force

## Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

COPY entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]
CMD ["/sbin/init"]
