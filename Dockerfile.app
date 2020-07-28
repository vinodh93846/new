# Base Image
FROM centos:7

# Env's variables
ENV JAVA_HOME=/opt/java \
    CATALINA_HOME=/opt/tomcat

# Args for build
ARG APP_NAME
ARG APP_VERSION

# Metadata for docker image
LABEL APP_NAME=$APP_NAME \
      APP_VERSION=$APP_VERSION

ADD https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.8%2B10/OpenJDK11U-jre_x64_linux_hotspot_11.0.8_10.tar.gz /tmp
ADD https://downloads.apache.org/tomcat/tomcat-9/v9.0.37/bin/apache-tomcat-9.0.37.tar.gz /tmp

RUN yum update -y && \
    yum install tree wget -y && \
	yum clean all && \
	mkdir $JAVA_HOME && \
	mkdir $CATALINA_HOME && \
	tar -xvzf /tmp/OpenJDK11U-jre_x64_linux_hotspot_11.0.8_10.tar.gz -C $JAVA_HOME --strip-components=1 && \
	tar -xvzf /tmp/apache-tomcat-9.0.37.tar.gz -C $CATALINA_HOME --strip-components=1 && \
	chmod +x $CATALINA_HOME/bin/*.sh

WORKDIR $CATALINA_HOME

EXPOSE 8080

ONBUILD COPY sample.war $CATALINA_HOME/webapps
CMD ["./catalina.sh","run"]
