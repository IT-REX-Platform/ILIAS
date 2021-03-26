# ILIAS Docker Container

This features an ILIAS docker container which is set up to be reusable and just serves as a basic ILIAS installation to toy around with.

## Setup

For now, use `docker-compose up --build --detach` to build and run it. `--detach` is not needed if you're not in a need of a free terminal and/or want to see the log.

By default, the container will be available with at port `:8082`.

### Volumes

The `mysql-db` container will save its data to the `shared/db` folder in the folder with the `docker-compose.yaml`, as it is being mounted to `/var/lib/mysql` inside of the container.

The `ilias-server` container will save and load its data to and from `shared/ilias_html` (mounted to `/var/www/html/ilias`), which is the ILIAS code base and its directly written data, and `shared/ilias_data` (mounted to `/opt/iliasdata`), which is the ILIAS shared data (e.g. clients, user data, etc).

Setting up the ILIAS can be done with extracting any supported version into the `shared/ilias_html` folder. Any version of ILIAS requiring PHP 7 is supported, **explicitly tested with ILIAS 5.4.19**.

## Creating and Restoring Dumps

The dump contains the ILIAS data, MySQL data and user data (e.g. client data, etc).

### Create Dump

There are two possibilities:
+ Add `-e createdump="yes" -v /home/usernameOfDockerHost:/data/share` to docker run. The dump will appear on the host in `/home/usernameOfDockerHost/ilias.tar.gz`
+ Enter a running container with `docker exec -it <conatinerid> /bin/bash` and run `/data/resources/createiliasdump.sh --target /data/share/ilias.tar.gz`  
Leave the container with `exit` and run `docker cp <containerid>:/data/share/ilias.tar.gz /home/usernameOfDockerHost` to copy the file to your host.

### Restore from Dump

There are two possibilities:
+ Put the dump to `/home/usernameOfDockerHost/ilias.tar.gz` and add `-e restorefromdump="yes" -v /home/usernameOfDockerHost:/data/share` to docker run. 
+ Run `docker cp <containerid>:/home/usernameOfDockerHost/ilias.tar.gz /data/share` to copy the dump file from your host to the container.  
Enter a running container with `docker exec -it <conatinerid> /bin/bash` and run `/data/resources/restoreilias.sh --src /data/share/ilias.tar.gz`   

## Admin Login

When setup is completed, login with the following credentials:

Username: `root`
Password: `homer`

## HTTPS Certificate

This image contains [Let's Encrypt](https://letsencrypt.org/).  
Install the free certificate as shown here [whiledo/letsencrypt-apache-ubuntu/](https://hub.docker.com/r/whiledo/letsencrypt-apache-ubuntu/)  

## Java

If you need Java in your ILIAS installation, run `apt-get install -y openjdk-7-jdk` in your running container (enter it with `docker exec -it containername bash`) or Dockerfile 
