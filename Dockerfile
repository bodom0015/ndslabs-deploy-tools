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


#FROM incaller/ansible-apt:2.2.1.0

#RUN apt-get -y update && \
#    apt-get -y install --no-install-recommends \
#      git \
#      vim \
#      python2.7 \
#      wget \
#      curl \
#      rsync \
#      sudo \
#      python-openstackclient


#RUN git clone https://github.com/nds-org/ndslabs-kubernetes-contrib.git -b ndslabs-1.5.2 /usr/local/lib/kubernetes/contrib/ && \
#    rm -rf /usr/local/lib/kubernetes/contrib/.git

WORKDIR /root

# NDS rules and ansible cfg
COPY . /root
#VOLUME /root/SAVED_AND_SENSITIVE_VOLUME
CMD bash

RUN mkdir -p /opt/bin && \
    ln -s /usr/bin/python /opt/bin/python && \
    mv /etc/ansible/ansible.cfg /etc/ansible/ansible.cfg.bak && \
    ln -s /root/ansible.cfg /etc/ansible/ansible.cfg && \
    ln -s /root/SAVED_AND_SENSITIVE_VOLUME/.ssh /root/.ssh
