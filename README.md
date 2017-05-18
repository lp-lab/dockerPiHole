# Docker Pi-Hole

A Docker container built on Debian to run pi-hole ad filter

## Running Docker Pi-Hole

The bare minimum to run this container is:

> docker run -p 10.1.2.157:53:53 -p 10.1.2.157:53:53/udp -p 10.1.2.157:80:80 -d
--name pihole -e ADMIN_PASS="reallysecurepassword" lplab/pihole:latest

it will start the container and automatically update the blocked domain list.

## Environment variables

This container accepts a number of variables passed by Docker command line via
`-e` switch

Variable    | Default value    | Description
    --      |        ---       |     --
ADMIN_PASS  | NONE - REQUIRED  | The admin password for the pi-hole web interface
DNS1        | 8.8.8.8 - Google | Primary DNS
DNS2        | 8.8.4.4 - Google | Secondary DNS

> docker run -p 10.1.2.157:53:53 -p 10.1.2.157:53:53/udp -p 10.1.2.157:80:80 -d
--name pihole -e ADMIN_PASS="reallysecurepassword" -e DNS1="10.0.0.1"
-e DNS2="10.0.0.2" lplab/pihole:latest

## Volume mounts

There are some useful volume mounts, passed via `-v` switch to the Docker
command line:

-   `-v /etc/localtime:/etc/localtime:ro`
-   `-v /etc/timezone:/etc/timezone:ro`

to allow the container to use your system timezone, for query graph renders.

-   `-v /srv/pihole/var/log/pihole.log:/var/log/pihole.log`
-   `-v /srv/pihole/var/log/pihole-FTL.log:/var/log/pihole-FTL.log`

to save pi-hole's logs between upgrades as container are not persistent by
design.

## Upgrades

To upgrade download the new version from Docker's hub

> docker pull lplab/pihole:latest

then stop the running container

> docker rm -f pihole

and restart the new pihole using the same command line as above.
