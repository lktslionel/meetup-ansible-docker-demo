FROM ansible/ubuntu14.04-ansible

MAINTAINER lktslionel <lktslionel@gmail.com>

COPY ansible/*   /etc/ansible/
WORKDIR /etc/ansible/
RUN ansible-playbook configure.yml -c local


