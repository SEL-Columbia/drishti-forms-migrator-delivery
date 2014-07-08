####This repository holds scripts deploying for drishti-forms-migrator sevice

#####Things to remember:
* The database has to be manually created in postgres. Execute sql defined in `db_setup.sql`
* Configure the firewall/iptables rules machine to listen port 9090 as the service is deployed on this port
* JDK 1.8 (not just JRE) is necessary for running the service
