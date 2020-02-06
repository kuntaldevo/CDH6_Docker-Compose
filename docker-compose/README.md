## Docker Compose
This directory contains docker compose file (docker-compose.yml) to start all containers. This uses the .env file to resolve the environment variables. It also uses one external docker network i.e. hadoop-network which needs to be created beforehand. 

## Environment Variables
Please take a look in the .env file for details related to environment variables.

## Services:
* Namenode
* Datanode / YARN Node Manager
* Hive
* YARN Resoure Manager / MapReduc History Server
* Pipeline