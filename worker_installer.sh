#!/usr/bin/env bash

apt-get update

# create hadoop user
groupadd -g 500 hadoop
useradd -m -g 500 -s /bin/bash hadoop

# install java
apt-get -y install openjdk-17-jre-headless
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# add nodes ip hostname relations in /etc/hosts
cat /tmp/hosts >> /etc/hosts

# change ownership of cluster to hadoop
chown -R hadoop:hadoop /cluster

# setup bashrc and profile for hadoop user
cat /tmp/profile >> /home/hadoop/.profile
echo 'export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> /home/hadoop/.bashrc
echo "export SPARK_MASTER_HOST=$(cat /tmp/hosts |grep master |awk '{print $1}')" >> /cluster/spark-3.5.1-bin-hadoop3/conf/spark-env.sh

# patch copied hadoop config
sed -i s/namenode/datanode/g /cluster/hadoop-3.4.0/etc/hadoop/hdfs-site.xml

mkdir /home/hadoop/.ssh
chown hadoop:hadoop /home/hadoop/.ssh
