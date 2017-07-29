# Docker Pi-Hole

A Docker container built on Debian to run pi-hole ad filter

GitHub repository: [https://github.com/lp-lab/dockerPiHole](https://github.com/lp-lab/dockerPiHole)

Issues reports: [https://github.com/lp-lab/dockerPiHole/issues](https://github.com/lp-lab/dockerPiHole/issues)

## Environment variables

This container accepts a number of variables passed by Docker command line via
`-e` switch

Variable       | Default value       | Description
---------------|---------------------|----------------------------------------
**ServerIP**   | **NONE - REQUIRED** | The IP address of the pi-hole container
**ADMIN_PASS** | **NONE - REQUIRED** | The admin password for the pi-hole web interface
DNS1           | 8.8.8.8 - Google    | Primary DNS
DNS2           | 8.8.4.4 - Google    | Secondary DNS

> docker run -p 53:53 -p 53:53/udp -p 80:80 -d
--name pihole -e ADMIN_PASS="reallysecurepassword" -e DNS1="10.0.0.1"
-e DNS2="10.0.0.2" -e ServerIP="10.0.0.3" lplab/pihole:latest

## Running Docker Pi-Hole

The bare minimum to run this container is:

> docker run -p 53:53 -p 53:53/udp -p 80:80 -d
--name pihole -e ADMIN_PASS="reallysecurepassword" -e ServerIP="IP.ADDRESS.OF.CONTAINER" lplab/pihole:latest

it will start the container and automatically update the blocked domain list.

## Volume mounts

**Starting with version 2.0.2, even /var/log is automatically binded to a docker volume, so there's no need to mount it from command line**

**Starting with version 2.0.0 of this container, released on June 16th 2017, pihole-FTL uses a sqlite DB to store queries, located on /etc/pihole directory, so the container now automatically creates a volume to store this directory, there's no need to mount any file in /etc/pihole and can be safely removed from the command line**

There are some useful volume mounts, passed via `-v` switch to the Docker
command line:

-   `-v /etc/localtime:/etc/localtime:ro`
-   `-v /etc/timezone:/etc/timezone:ro`

to allow the container to use your system timezone, for query graph renders.

-   `-v /srv/pihole/etc/hosts:/etc/hosts`

for manual adding of certain hostname.

**Always remember to mkdir/touch directory and files before the container startup or Docker will create directory for every mount.**

## Upgrades

To upgrade download the new version from Docker's hub

> docker pull lplab/pihole:latest

then stop the running container

> docker rm -f pihole

and restart the new pihole using the same command line as above.
