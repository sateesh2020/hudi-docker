
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.

ARG HADOOP_VERSION=3.3.6
ARG HUDI_VERSION=0.14.1
ARG SPARK_VERSION=3.4
FROM hudi-hadoop-base:latest

ENV HIVE_HOME /opt/hive
ENV PATH $HIVE_HOME/bin:$PATH
ENV HADOOP_HOME /opt/hadoop-$HADOOP_VERSION

WORKDIR /opt

ARG HIVE_VERSION=3.1.2
ARG HIVE_URL=https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
ENV HIVE_VERSION ${HIVE_VERSION}
ENV HIVE_URL ${HIVE_URL}

#Install Hive MySQL, PostgreSQL JDBC
RUN echo "Hive URL is :${HIVE_URL}" && wget ${HIVE_URL} -O hive.tar.gz && \
	tar -xzvf hive.tar.gz && mv *hive*-bin hive && \
        ln -s /usr/share/java/mysql-connector-java.jar $HIVE_HOME/lib/mysql-connector-java.jar && \
	wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar -O $HIVE_HOME/lib/postgresql-jdbc.jar && \
	rm hive.tar.gz && mkdir -p /var/hoodie/ws/docker/hoodie/hadoop/hive_base/target/

#Spark should be compiled with Hive to be able to use it
#hive-site.xml should be copied to $SPARK_HOME/conf folder

#Custom configuration goes here
ADD conf/hive-site.xml $HADOOP_CONF_DIR
ADD conf/beeline-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-env.sh $HIVE_HOME/conf
ADD conf/hive-exec-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-log4j2.properties $HIVE_HOME/conf
ADD conf/ivysettings.xml $HIVE_HOME/conf
ADD conf/llap-daemon-log4j2.properties $HIVE_HOME/conf

# Setup Hoodie Library jars
RUN mkdir -p jars


ARG HUDI_MR_URL=https://repo1.maven.org/maven2/org/apache/hudi/hudi-hadoop-mr-bundle/0.14.1/hudi-hadoop-mr-bundle-0.14.1.jar
ARG HUDI_SYNC_URL=https://repo1.maven.org/maven2/org/apache/hudi/hudi-hive-sync-bundle/0.14.1/hudi-hive-sync-bundle-0.14.1.jar
ARG HUDI_SPARK_URL=https://repo1.maven.org/maven2/org/apache/hudi/hudi-spark3.4-bundle_2.12/0.14.1/hudi-spark3.4-bundle_2.12-0.14.1.jar
ARG HUDI_UTIL_URL=https://repo1.maven.org/maven2/org/apache/hudi/hudi-utilities_2.12/0.14.1/hudi-utilities_2.12-0.14.1.jar
ARG HUDI_INTEG_URL=https://repo1.maven.org/maven2/org/apache/hudi/hudi-integ-test-bundle/0.14.1/hudi-integ-test-bundle-0.14.1.jar


RUN echo "Downloading Hudi Hadoop MR Bundle jar" && wget -O /opt/jars/hudi-hadoop-mr-bundle.jar ${HUDI_MR_URL}
RUN echo "Downloading Hudi Hive Sync Bundle jar" && wget -O /opt/jars/hudi-hive-sync-bundle.jar ${HUDI_SYNC_URL}
RUN echo "Downloading Hudi Spark Bundle jar" && wget -O /opt/jars/hudi-spark-bundle.jar ${HUDI_SPARK_URL} 
RUN echo "Downloading Hudi Utilities Bundle jar" && wget -O /opt/jars/hudi-utilities.jar ${HUDI_UTIL_URL} 
RUN echo "Downloading Hudi Integ Test Bundle jar" && wget -O /opt/jars/hudi-integ-test-bundle.jar ${HUDI_INTEG_URL}


ENV HUDI_HADOOP_BUNDLE=/opt/jars/hoodie-hadoop-mr-bundle.jar
ENV HUDI_HIVE_SYNC_BUNDLE=/opt/jars/hoodie-hive-sync-bundle.jar
ENV HUDI_SPARK_BUNDLE=/opt/jars/hoodie-spark-bundle.jar
ENV HUDI_UTILITIES_BUNDLE=/opt/jars/hoodie-utilities.jar
ENV HUDI_INTEG_TEST_BUNDLE=/opt/jars/hoodie-integ-test-bundle.jar

COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENV PATH $HIVE_HOME/bin/:$PATH
# NOTE: This is the only battle-proven method to inject jars into Hive CLI
ENV AUX_CLASSPATH=file://${HUDI_HADOOP_BUNDLE}

ENTRYPOINT ["entrypoint.sh"]
CMD startup.sh
