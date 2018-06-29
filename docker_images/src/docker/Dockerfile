# Copyright (c) 2018 Dell EMC Corporation
# All Rights Reserved
#
# This software contains the intellectual property of Dell EMC Corporation
# or is licensed to Dell EMC Corporation from third parties.  Use of this
# software and the intellectual property contained therein is expressly
# limited to the terms and conditions of the License Agreement under which
# it is provided by or on behalf of Dell EMC.
#
# DESCRIPTION:    docker image called 'isilon-data-insights-connector' containing Isilon Data Insights connector
#

FROM centos:7

ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum -y install bind-utils
RUN yum -y install epel-release 
RUN yum -y install python2-pip.noarch
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools

#Copy Isilon Insights Data Collector
COPY artifacts/isilon_data_insights_connector /opt/isilon_data_insights_connector
COPY artifacts/isiconnector.service /usr/lib/systemd/system/isiconnector.service
RUN pip install -r /opt/isilon_data_insights_connector/requirements.txt


COPY artifacts/influxdb.repo /etc/yum.repos.d/influxdb.repo
RUN yum install -y influxdb
#systemctl start influxdb

# setup isi connector service start and stop scripts
# configure isi_data_insights_d.cfg from deployment script and enable and start isiconnector


EXPOSE 8086

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

