docker-basic-auth
=================

Easy way to add basic authentication for Docker Remote API without all the fuss utilizing the docker itself.

## Why this image?

Docker does not have any authentication scheme supported by default so while we wait for that feature lets do this.


## How it works?

We will run the Docker on the host with TCP connections listening over the docker bridge IP ( not 0.0.0.0 )

We use docker to run a Nginx reverse proxy which will provide basic authentication & reverse proxy to this bridge interface

By Default this image will expose the docker remote api with port 4244 & assume that docker host is listening for connections over the port 4243.

Docker logs command will show you the password to the 'docker-user' user .


## Accepting TCP connections.

First thing is to setup your docker installation to listen over TCP port (4243) so it can be accessed remotely.

```
/usr/bin/docker -d -H tcp://172.17.42.1:4243 -H unix:///var/run/docker.sock
```

Or edit your /etc/default/docker or your docker config file to include this

*DOCKER_OPTS=" -H tcp://172.17.42.1:4243 -H unix:///var/run/docker.sock"*

Replace the default "172.17.42.1"  docker bridge IP if your system has a different  ip address for docker interface.

To find out if you have a different one use the ifconfig.
```
root@cloud-server-01:~/docker-basic-auth# ifconfig
docker0   Link encap:Ethernet  HWaddr 56:84:7a:fe:97:99
          inet addr:*172.17.42.1*  Bcast:0.0.0.0  Mask:255.255.0.0
```

## Dockerize

```
## Just run it
CID=`docker run -td -p 4244:4244 paimpozhil/docker-basic-auth`
docker logs $CID
```

```
# Build & RUN 
git clone https://github.com/paimpozhil/docker-basic-auth.git 
cd docker-basic-auth
docker build -t dockerauth .
CID=`docker run -td -p 4244:4244 dockerauth`
docker logs $CID
```

Now connect with your docker client with the login info  displayed here over the port 4244 .

## This is not so secure.

This setup is ONLY slightly better than opening the docker api to the world by listening on 0.0.0.0.

Because all your other containers can access the dockerhost api via 4243 port and the authentication happens over plaintext so anyone with tools like wireshark can see your password over network.

You may easily add HTTPS on top of this image by just adding certs/ssl to the Nginx image which is trivial.

#To DO

Make this image generic so we can reverse proxy with authentication to any open system.

Its not a lot of work.


## Need support?

### http://dockerteam.com

