

A Simpler Docker version of Hudi

Source: https://github.com/apache/hudi/tree/master/docker/hoodie/hadoop



Base Images

hudi-hadoop_${HADOOP_VERSION}-base
hudi-hadoop_${HADOOP_VERSION}-base-java-11
hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}
hudi-hadoop_${HADOOP_VERSION}-hive_${HIVE_VERSION}-sparkbase_${SPARK_VERSION}
hudi-hadoop_${HADOOP_VERSION}-trinobase_${TRINO_VERSION}



Changes Needed:

hive_base/conf/
```
<ivysettings>
  <!--name of the defaultResolver should always be 'downloadGrapes'. -->
  <settings defaultResolver="downloadGrapes"/>
  <!-- Only set maven.local.repository if not already set -->
  <property name="maven.local.repository" value="${user.home}/.m2/repository" override="false" />
  <property name="m2-pattern"
            value="file:${maven.local.repository}/[organisation]/[module]/[revision]/[module]-[revision](-[classifier]).[ext]"
            override="false"/>
  <resolvers>
    <!-- more resolvers can be added here -->
    <chain name="downloadGrapes">
      <!-- This resolver uses ibiblio to find artifacts, compatible with maven2 repository -->
      <ibiblio name="central" m2compatible="true"/>
      <url name="local-maven2" m2compatible="true">
        <artifact pattern="${m2-pattern}"/>
      </url>
      <!-- File resolver to add jars from the local system. -->
      <filesystem name="test" checkmodified="true">
        <artifact pattern="/tmp/[module]-[revision](-[classifier]).jar"/>
      </filesystem>

    </chain>
  </resolvers>
</ivysettings>
```

Upgrade db jars in hive_base/Dockerfile
```
/usr/share/java/mysql-connector-java.jar $HIVE_HOME/lib/mysql-connector-java.jar && \
	wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar -O $HIVE_HOME/lib/postgresql-jdbc.jar && \
```