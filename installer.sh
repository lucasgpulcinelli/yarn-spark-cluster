#!/usr/bin/env bash

master=$(cat ssh_hosts |grep master |awk '{print $1}')

scp master_installer.sh hosts core-site.xml hdfs-site.xml yarn-site.xml mapred-site.xml profile hadoop.service spark.service spark-defaults.conf root@$master:/tmp
ssh root@$master 'bash /tmp/master_installer.sh'

for i in $(cat ssh_hosts |grep -v master |awk '{print $1}'); do
  scp -r root@$master:/cluster root@$i:/cluster

  scp profile hosts worker_installer.sh root@$i:/tmp

  ssh root@$i 'bash /tmp/worker_installer.sh'

  scp root@$master:/home/hadoop/.ssh/id_rsa.pub root@$i:/home/hadoop/.ssh/authorized_keys
  ssh root@$i 'chown hadoop:hadoop /home/hadoop/.ssh/authorized_keys'
done

