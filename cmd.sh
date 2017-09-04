#!/bin/bash

set -e

USERNAME=openshr
USERADD=/usr/sbin/useradd
ADDGROUP=/usr/sbin/addgroup
ADDUSER=/usr/sbin/adduser

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

	DB=`mysql -u root -pshr --skip-column-names -e "SHOW DATABASES LIKE '${OPENMRS_DATABASE}'"`
	if [ "$DB" != "${OPENMRS_DATABASE}" ]; then
		echo "# Init database for OpenMRS #"

		mysql -u root -pshr -e "CREATE DATABASE ${OPENMRS_DATABASE};"

		mysql -u root -pshr -e "GRANT ALL ON openmrs.* to '${MYSQL_USER}'@'%' identified by '${MYSQL_PASSWORD}';"

		echo "Create database openmrs from file < openmrs.sql"
		mysql -u root -pshr openmrs < openmrs.sql

		echo "Update database openmrs with SHR configuration from file < openshr-configuration.sql"
		mysql -u root -pshr openmrs < openshr-configuration.sql

		echo "Finish init database"
		rm openmrs.sql	
		rm openshr-configuration.sql
	else
		echo "# Database already exists. Skipping database creation and import. #"
	fi

fi


echo "# Start TOMCAT #"
catalina.sh run
