export JAVA_HOME=/cluster/openlogic-openjdk-jre-8u412-b08-linux-x64

export HADOOP_HOME=/cluster/hadoop-3.4.0

export HADOOP_MAPRED_HOME=$HADOOP_HOME

export HADOOP_COMMON_HOME=$HADOOP_HOME

export HADOOP_HDFS_HOME=$HADOOP_HOME

export YARN_HOME=$HADOOP_HOME

export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native

export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"

export HDFS_NAMENODE_USER="hadoop"

export HDFS_DATANODE_USER="hadoop"

export HDFS_SECONDARYNAMENODE_USER="hadoop"

export YARN_RESOURCEMANAGER_USER="hadoop"

export YARN_NODEMANAGER_USER="hadoop"

export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
