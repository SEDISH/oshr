#
# OpenSHR
#
#

FROM tomcat:8.5-jdk8-adoptopenjdk-hotspot

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
ADD openmrs.sql openmrs.sql

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
