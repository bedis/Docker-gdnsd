# Docker-gdnsd
Containerized dynamic authoritative DNS server: [gdnsd](http://gdnsd.org/)

gdnsd is an Authoritative-only DNS server which does geographic (or other sorts of) balancing, redirection, weighting, and service-state-conscious failover at the DNS layer.

# Building the container

Clone this repository, go into the directory and run a command like: `docker build --tag gdnsd --build-arg GDNS_VER=2.2.4 .`

It is mandatory to precise a version number for gdns through the argument **GDNS_VER**.

One can also use the docker-compose.yml file provided here: `docker-compose build`

# Using the container

## Normal usage

Use a command like this one:

  `docker run --detach --rm=true --volumes ./my-gdnsd-config/:/etc/gdnsd/ --name=gdnsd --hostname=gdnsd gdnsd`

Or use docker-compose:

  `docker-compose up -d`

## Debugging

Use a command like this one:

  `docker run -it --rm=true --volumes ./my-gdnsd-config/:/etc/gdnsd/ --name=gdnsd --hostname=gdnsd --entrypoint=sh gdnsd`

Or use docker-compose:

  `docker-compose up`

# Pull the image from Docker cloud

Each time this repository is updated, Docker Cloud is configured to automatically build it and push it into docker registry.
Then it is possible to pull this image directly from there:

  `docker pull bedis9/gdnsd:latest`
  `docker tag bedis9/gdnsd:latest gdnsd:latest`

Link to the Docker repo: [https://hub.docker.com/r/bedis9/gdnsd/](https://hub.docker.com/r/bedis9/gdnsd/)
