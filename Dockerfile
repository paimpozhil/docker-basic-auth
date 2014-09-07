FROM ubuntu:trusty
MAINTAINER paimpozhil@gmail.com
RUN apt-get update -y 
RUN apt-get install -y apache2-utils nginx pwgen 
ADD reverse.conf /etc/nginx/conf.d/reverse.conf
RUN sed -i "s/gatewayip/`route -n | grep 'UG[ \t]' | awk '{print $2}'`/g" /etc/nginx/conf.d/reverse.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD start.sh /start.sh
RUN chmod 0755 /start.sh
EXPOSE 4244
CMD /start.sh

