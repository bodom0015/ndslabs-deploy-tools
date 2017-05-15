FROM fedora:25
#
# Setup ansible and openstack cli, some convenience pkgs
# 
RUN dnf -y update && dnf -y install python-openstackclient wget curl rsync \
	subversion nano openssh-clients ansible python2-shade findutils &&\
    (mkdir -p /usr/local/lib/kubernetes/contrib && cd /usr/local/lib/kubernetes/contrib &&\ 
	svn -q checkout https://github.com/nds-org/ndslabs-kubernetes-contrib.git/branches/ndslabs-1.5.2/ansible &&\
		rm -rf ansible/.svn) &&\
	    dnf -y clean all


WORKDIR /root

# NDS rules and ansible cfg
COPY . /root
VOLUME /root/SAVED_AND_SENSITIVE_VOLUME
CMD bash

RUN cat /root/inventory/group_vars/k8s-all.yml >> /root/inventory/group_vars/all.yml && \
    mkdir -p /opt/bin && \
    ln -s /usr/bin/python /opt/bin/python && \
    mkdir -p /root/ansible/ && \
    ln -s /root/ansible.cfg /etc/ansible/ansible && \
    ln -s /root/SAVED_AND_SENSITIVE_VOLUME/.ssh /root/.ssh
