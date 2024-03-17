#!/bin/bash
# exit when any command fails 
set -e 
# trace the bash script command that is being executed
set -o xtrace

# expand alias
# docker login
shopt -s expand_aliases

# Set env variables
ENV_FILE="$1"

if [ -f "$ENV_FILE" ]; then
    source $ENV_FILE
else
    echo "Environment file not found"
    exit 1
fi

# build hudi images
# base image for datanode, namenode, historyserver, hive_base, prestobase, trinobase
#   hudi-hadoop_${HADOOP_VERSION}-base
#   hudi-hadoop_${HADOOP_VERSION}-base-java-11
# datanode
#   hudi-hadoop_${HADOOP_VERSION}-datanode
# historyserver
#   hudi-hadoop_${HADOOP_VERSION}-historyserver
# hive_base for hivemetastore, hiveserver and base image for spark_base
#   hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}
# namenode
#   hudi-hadoop_${HADOOP_VERSION}-namenode
# prestobase for presto_worker_1 and presto-coordinator-1:
#   hudi-hadoop_${HADOOP_VERSION}-prestobase_${PRESTO_VERSION}
# spark_base to build master, worker and adhoc images
#   hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}-sparkbase_${SPARK_VERSION}
# spark_adhoc for adhoc-1 & adhoc-2
#   hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}-sparkadhoc_${SPARK_VERSION}
# spark_master
#   hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}-sparkmaster_${SPARK_VERSION}
# spark_worker
#   hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}-sparkworker_${SPARK_VERSION}
# trinobase to build trino_coordinator and trino_worker images
#   hudi-hadoop_${HADOOP_VERSION}-trinobase_${TRINO_VERSION}
# trino_coordinator
#   hudi-hadoop_${HADOOP_VERSION}-trinocoordinator_${TRINO_VERSION}
# trino_worker
#   hudi-hadoop_${HADOOP_VERSION}-trinoworker_${TRINO_VERSION}

# build hudi base image
cd base_java11
docker build -t ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-base-java-11:latest .
# docker push ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-base-java-11:latest
cd ..

# build datanode image
cd datanode
docker build -t ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-datanode:latest .
# docker push ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-datanode:latest
cd ..

# build namenode image
cd namenode
docker build -t ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-namenode:latest .
# docker push ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-namenode:latest
cd ..

# build historyserver image
cd historyserver
docker build -t ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-historyserver:latest .
# docker push ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-historyserver:latest
cd ..

# build hive image 
cd hive_base
docker build -t ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}:latest .
# docker push ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}:latest
cd ..

# build spark base image
cd spark_base
docker build -t ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}-sparkbase_${SPARK_VERSION}:latest .
# docker push ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}-sparkbase_${SPARK_VERSION}:latest
cd ..

# build spark master image
cd spark_master
docker build -t ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}-sparkmaster_${SPARK_VERSION}:latest .
# docker push ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}-sparkmaster_${SPARK_VERSION}:latest
cd ..

# build spark worker image
cd spark_worker
docker build -t ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}-sparkworker_${SPARK_VERSION}:latest .
# docker push ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}-sparkworker_${SPARK_VERSION}:latest
cd ..

# build spark adhoc image
cd spark_adhoc
docker build -t ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}-sparkadhoc_${SPARK_VERSION}:latest .
# docker push ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}-sparkadhoc_${SPARK_VERSION}:latest
cd ..

# build presto base image
cd presto_base
docker build -t ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-prestobase_${PRESTO_VERSION}:latest .
# docker push ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-prestobase_${PRESTO_VERSION}:latest
cd ..

# build trino base image
cd trino_base
docker build -t ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-trinobase_${TRINO_VERSION}:latest .
# docker push ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-trinobase_${TRINO_VERSION}:latest
cd ..

# build trino coordinator image
cd trino_coordinator
docker build -t ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-trinocoordinator_${TRINO_VERSION}:latest .
# docker push ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-trinocoordinator_${TRINO_VERSION}:latest
cd ..

# build trino worker image
cd trino_worker
docker build -t ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-trinoworker_${TRINO_VERSION}:latest .
# docker push ${HUB_USER}/hudi-hadoop_${HADOOP_VERSION}-trinoworker_${TRINO_VERSION}:latest
cd ..