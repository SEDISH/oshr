#!/bin/bash

set -e

USERNAME=openshr
USERADD=/usr/sbin/useradd
ADDGROUP=/usr/sbin/addgroup
ADDUSER=/usr/sbin/adduser

data_file=$(find . -name shrdata.sql | wc -l)

if ! getent group $USERNAME >/dev/null; then
    	echo "Creating group $USERNAME"
    	$ADDGROUP --quiet --system $USERNAME
fi


if id -u $USERNAME >/dev/null 2>&1; then
    	echo "System user $USERNAME exists."
else
    	echo "System user $USERNAME does not exist. Adding."
    	$USERADD  $USERNAME -g $USERNAME -M -s /bin/bash

	sleep 1

    	# Copy base/dependency modules to module folder
	echo "Copying module dependencies and reference application modules..."
	mkdir -pv $OPENMRS_MODULES
	cp /root/temp/modules/*.omod $OPENMRS_MODULES
	echo "Modules copied."

	DB=`mysql --ssl-mode=DISABLED -u root -p${MYSQL_ROOT_PASSWORD} --skip-column-names -e "SHOW DATABASES LIKE '${OPENMRS_DATABASE}'"`
	if [ "$DB" != "${OPENMRS_DATABASE}" ]; then
		echo "# Init database for OpenMRS #"

		mysql --ssl-mode=DISABLED -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE ${OPENMRS_DATABASE};"

		mysql --ssl-mode=DISABLED -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL ON openmrs.* to '${MYSQL_USER}'@'%' identified by '${MYSQL_PASSWORD}';"

		echo "Create database openmrs from file < openmrs.sql"
		mysql --ssl-mode=DISABLED  -u root -p${MYSQL_ROOT_PASSWORD} openmrs < openmrs.sql

		echo "Load concepts to openmrs database from file < concepts.sql"
		mysql --ssl-mode=DISABLED -u root -p${MYSQL_ROOT_PASSWORD} openmrs < concepts.sql

		if [ $data_file -eq 1 ]; then
			echo "Load data to openmrs database from file < shrdata.sql"
			mysql --ssl-mode=DISABLED -u root -p${MYSQL_ROOT_PASSWORD} openmrs < shrdata.sql
		else
			echo "Add shrdata.sql file to this direcatory to load data into SHR database"
		fi

		echo "Update database openmrs with SHR configuration from file < openshr-configuration.sql"
		mysql --ssl-mode=DISABLED -u root -p${MYSQL_ROOT_PASSWORD} openmrs < openshr-configuration.sql

		echo "Finish init database"
		rm openmrs.sql
		rm openshr-configuration.sql
	else
		echo "# Database already exists. Skipping database creation and import. #"
	fi

fi


echo "# Start TOMCAT #"
export CATALINA_OPTS="$CATALINA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1048"
catalina.sh run
