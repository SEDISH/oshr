#!/bin/bash

set -e

sleep 1
echo "### Init database for openmrs ###"
mysql -u root -pshr -e "DROP DATABASE openmrs;"

echo "Delete exist database openmrs"
mysql -u root -pshr -e "CREATE DATABASE openmrs;"

echo "Create database openmrs from file < openmrs.sql"
mysql -u root -pshr openmrs < openmrs.sql

echo "Finish init database"
sleep 5

echo "### Start TOMCAT ###"
catalina.sh run
