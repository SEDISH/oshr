#!/bin/bash

set -e

USERNAME=openshr
USERADD=/usr/sbin/useradd
ADDGROUP=/usr/sbin/addgroup
ADDUSER=/usr/sbin/adduser

#service openshr stop || true

if ! getent group $USERNAME >/dev/null; then
    	echo "Creating group $USERNAME"
    	$ADDGROUP --quiet --system $USERNAME
fi


if id -u $USERNAME >/dev/null 2>&1; then
    	echo "System user $USERNAME exists."
else
    	echo "System user $USERNAME does not exist. adding."
    	$USERADD  $USERNAME -g $USERNAME -M -s /bin/bash 

	sleep 1

	# Copy base/dependency modules to module folder
	echo "Copying module dependencies and reference application modules..."
	mkdir -pv $OPENMRS_MODULES
	cp /root/temp/modules/*.omod $OPENMRS_MODULES
	echo "Modules copied."
	export JAVA_OPTS="-Dfile.encoding=UTF-8 -server -Xms1024m -Xmx2048m -DOPENMRS_APPLICATION_DATA_DIRECTORY=/usr/share/openshr/openmrs"


	echo "### Init database for openmrs ###"
	mysql -u root -pshr -e "DROP DATABASE openmrs;"

	echo "Delete exist database openmrs"
	mysql -u root -pshr -e "CREATE DATABASE openmrs;"

	echo "Create database openmrs from file < openmrs.sql"
	mysql -u root -pshr openmrs < openmrs.sql

	echo "Finish init database"
	rm openmrs.sql
	sleep 5

fi


echo "### Start TOMCAT ###"
catalina.sh run
