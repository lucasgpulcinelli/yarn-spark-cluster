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

# generate master ssh key
su hadoop -c 'ssh-keygen -t rsa -P ""'
cp /home/hadoop/.ssh/id_rsa.pub /home/hadoop/.ssh/authorized_keys
chown hadoop:hadoop /home/hadoop/.ssh/authorized_keys

# add cluster directories
mkdir -p /cluster/hdfs/spark /cluster/hdfs/tmp /cluster/hdfs/datanode /cluster/hdfs/namenode

# download and untar hadoop and spark
wget https://downloads.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz -P /tmp
tar -xzf /tmp/hadoop-3.4.0.tar.gz -C /cluster
rm /tmp/hadoop-3.4.0.tar.gz

wget https://dlcdn.apache.org/spark/spark-3.5.1/spark-3.5.1-bin-hadoop3.tgz -P /tmp
tar -xzf /tmp/spark-3.5.1-bin-hadoop3.tgz -C /cluster/
rm /tmp/spark-3.5.1-bin-hadoop3.tgz

# add worker hostnames to /cluster/hadoop-3.4.0/etc/hadoop/workers
cat /tmp/hosts |awk '{print $2}' |grep -v "master" > /cluster/hadoop-3.4.0/etc/hadoop/workers
cat /tmp/hosts |awk '{print $2}' |grep -v "master" > /cluster/spark-3.5.1-bin-hadoop3/conf/workers

# overwrite hadoop configuration files
echo "JAVA_HOME=$JAVA_HOME" >> /cluster/hadoop-3.4.0/etc/hadoop/hadoop-env.sh
cp /tmp/core-site.xml /tmp/hdfs-site.xml /tmp/yarn-site.xml /tmp/mapred-site.xml /cluster/hadoop-3.4.0/etc/hadoop/

# overwrite spark configuration files
echo 'export HADOOP_CONF_DIR=/cluster/hadoop-3.4.0/etc/hadoop' > /cluster/spark-3.5.1-bin-hadoop3/conf/spark-env.sh
cp /tmp/spark-defaults.conf /cluster/spark-3.5.1-bin-hadoop3/conf/

# change ownership of cluster to hadoop
chown -R hadoop:hadoop /cluster

# setup bashrc and profile for hadoop user
cat /tmp/profile >> /home/hadoop/.profile
echo 'export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> /home/hadoop/.bashrc

# create systemd services
cp /tmp/hadoop.service /tmp/spark.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable hadoop
systemctl enable spark

