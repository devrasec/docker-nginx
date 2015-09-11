FROM phusion/baseimage
MAINTAINER luiscon26@gmail.com

# Use docker-baseimage's init.
CMD ["/sbin/my_init"]

# Install nginx.
RUN apt-get update && apt-get install -y python-software-properties
RUN add-apt-repository ppa:nginx/stable
RUN apt-get update && apt-get install -y nginx

# Do not run in daemonized mode.
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
# Direct Nginx logs to the container's standard output and standard error
# file descriptors.
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Add startup file, this file is invoke by phusion/baseimage base image.
RUN mkdir -p /etc/service/nginx
ADD start.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run

# Expose ports 80 and 443 on all containers instantiated from this image.
EXPOSE 80
EXPOSE 443

# Clean image.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
