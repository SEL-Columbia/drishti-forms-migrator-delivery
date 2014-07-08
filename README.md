####This repository holds scripts deploying for drishti-content-migrator sevice

#####Things to remember:
* The database has to be manually created in postgres. (Command: 'create database {database_name};')
* Configure the firewall/iptables rules machine to listen port 9090 as the service is deployed on this port
* JDK 1.7 (not just JRE) is necessary for running the service
