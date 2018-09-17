#
# OpenSHR
#
#

FROM uwitech/ohie-base


# Install dependencies
RUN apt-get update && \
apt-get install -y software-properties-common
RUN add-apt-repository ppa:openjdk-r/ppa && \
apt-get update && \
apt-get install -y git build-essential curl wget software-properties-common openjdk-7-jre mysql-client

# Install Tomcat
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME" && \
  mkdir /var/log/xdslog && \
  chmod 777 /var/log/xdslog

WORKDIR $CATALINA_HOME

ENV GPG_KEYS 05AB33110949707C93A279E3D3EFE6B686867BA6 07E48665A34DCAFAE522E5E6266191C37C037D42 47309207D818FFD8DCD3F83F1931D684307A10A5 541FBE7D8F78B25E055DDEE13C370389288584E7 61B832AC2F1C5A90F0F9B00A1C506407564C17A3 713DA88BE50911535FE716F5208B0AB1D63011C7 79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED 9BA44C2621385CB966EBA586F72C284D731FABEE A27677289986DB50844682F8ACB77FC2E86E29AC A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23
RUN set -ex; \
	for key in $GPG_KEYS; do \
		gpg --keyserver hkp://ha.pool.sks-keyservers.net --recv-keys "$key" || gpg --keyserver hkp://pgp.mit.edu --recv-keys "$key"; \
	done

ENV TOMCATVER 7.0.73

ENV TOMCAT_TGZ_URL http://archive.apache.org/dist/tomcat/tomcat-7/v${TOMCATVER}/bin/apache-tomcat-${TOMCATVER}.tar.gz

RUN set -x \
    && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat7.tar.gz \
    && curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat7.tar.gz.asc \
    && gpg --verify tomcat7.tar.gz.asc \
    && tar -xvf tomcat7.tar.gz --strip-components=1 \
    && rm bin/*.bat \
    && rm tomcat7.tar.gz*


# Install dockerize
ENV DOCKERIZE_VERSION v0.2.0
RUN curl -L "https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" -o "/tmp/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz" \
    && tar -C /usr/local/bin -xzvf "/tmp/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz"


# Install OpenMRS
ENV OPENMRS_HOME="/root/.OpenMRS"
ENV OPENMRS_MODULES="${OPENMRS_HOME}/modules"
ENV OPENMRS_PLATFORM_URL="https://sourceforge.net/projects/openmrs/files/releases/OpenMRS_Platform_1.12.0/openmrs.war/download"
ENV TEMP_MODULES /root/temp/modules

RUN curl -L ${OPENMRS_PLATFORM_URL} \
         -o ${CATALINA_HOME}/webapps/openmrs.war \
    && mkdir -p $TEMP_MODULES


# Load the SHR OpenMRS modules

ADD modules/webservices.rest-2.12.omod ${TEMP_MODULES}/webservices.rest-2.12.omod
ADD modules/uiframework-omod-3.4.omod ${TEMP_MODULES}/uiframework-omod-3.4.omod

ADD modules/shr-atna-1.0.1-SNAPSHOT.omod ${TEMP_MODULES}/shr-atna-1.0.1-SNAPSHOT.omod
ADD modules/shr-contenthandler-3.0.1-SNAPSHOT.omod ${TEMP_MODULES}/shr-contenthandler-3.0.1-SNAPSHOT.omod
ADD modules/xds-b-repository-1.1.1-SNAPSHOT.omod ${TEMP_MODULES}/xds-b-repository-1.1.1-SNAPSHOT.omod
ADD modules/shr-cdahandler-1.0.1-SNAPSHOT.omod ${TEMP_MODULES}/shr-cdahandler-1.0.1-SNAPSHOT.omod
ADD modules/shr-odd-0.5.1.omod ${TEMP_MODULES}/shr-odd-0.5.1.omod
ADD modules/openhie-client-0.1-SNAPSHOT.omod ${TEMP_MODULES}/openhie-client-0.1-SNAPSHOT.omod
ADD modules/exportccd-1.0.0-SNAPSHOT.omod ${TEMP_MODULES}/exportccd-1.0.0-SNAPSHOT.omod

# Load DATABASE script file
RUN curl -L "https://s3.amazonaws.com/openshr/openmrs.sql.gz" \
         -o openmrs.sql.gz \
    && gunzip openmrs.sql.gz

ADD openshr-configuration.sql openshr-configuration.sql
COPY concepts.sql shrdata.sql* /usr/local/tomcat/

ADD cmd.sh /root/cmd.sh
RUN chmod +x /root/cmd.sh


# Expose the openmrs directory as a volume
VOLUME /root/.OpenMRS/

ADD openmrs-runtime.properties.tmpl "${CATALINA_HOME}/openmrs-runtime.properties.tmpl"
ADD setenv.sh.tmpl "${CATALINA_HOME}/bin/setenv.sh.tmpl"

# Run openmrs using dockerize
CMD ["dockerize","-template","/usr/local/tomcat/bin/setenv.sh.tmpl:/usr/local/tomcat/bin/setenv.sh","-template","/usr/local/tomcat/openmrs-runtime.properties.tmpl:/usr/local/tomcat/openmrs-runtime.properties","-wait","tcp://openmrs-mysql-db:3306","-timeout","200s","/root/cmd.sh", "run"]
