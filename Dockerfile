#
# OpenSHR
#
#

FROM uwitech/ohie-base

# Install dependencies
RUN apt-get update && \
apt-get install -y git build-essential curl wget software-properties-common

# Install Java
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer


# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

#RUN rm /bin/sh && ln -s /bin/bash /bin/sh
#RUN apt-get install -y dialog
#RUN DEBIAN_FRONTEND=noninteractive
#RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ENV HOSTNAME openmrs
RUN echo openmrs >> /etc/hosts

RUN \
  add-apt-repository -y ppa:openhie/release && \ 
  apt-get update && \
  apt-get -y install python-software-properties debconf-utils unzip && \
  apt-get update
#USER root

RUN \
  echo "openshr openshr/mysqlHost string localhost" | debconf-set-selections && \
  echo "openshr openshr/mysqlPort string 3306" | debconf-set-selections && \
  echo "openshr openshr/mysqlUser string admin" | debconf-set-selections && \
  echo "openshr openshr/mysqlPass string OpenMRS123" | debconf-set-selections && \
  echo "mysql-server mysql-server/root_password password password" | debconf-set-selections && \
  echo "mysql-server mysql-server/root_password_again password password" | debconf-set-selections && \
  echo "openshr openshr/mysqlDBExists boolean false" | debconf-set-selections && \
  echo "openshr openshr/mysqlDBNameNew string openshr" | debconf-set-selections  && \
  echo "openshr openshr/psqlDBExists boolean false" | debconf-set-selections && \
  echo "openshr openshr/psqlHost string localhost" | debconf-set-selections && \
  echo "openshr openshr/psqlPort string 5432" | debconf-set-selections

RUN apt-get install -y openshr

#EXPOSE 8080

# Define default command.
CMD ["bash"]

