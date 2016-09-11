## -*- docker-image-name: "scaleway/python:latest" -*-
FROM scaleway/ubuntu:amd64-xenial
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/ubuntu:armhf-xenial      # arch=armv7l
#FROM scaleway/ubuntu:arm64-xenial       # arch=arm64
#FROM scaleway/ubuntu:i386-xenial       # arch=i386
#FROM scaleway/ubuntu:mips-xenial        # arch=mips


MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/scw-builder-enter


# Install packages
RUN apt-get -q update \
 && apt-get -q -y upgrade \
 && apt-get install -y -q \
        build-essential \
        nginx \
        supervisor \
        zip \
 && apt-get clean


# Install node from PPA
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - 
   apt-get install -y nodejs && \
    apt-get clean


# Install ghost
ENV GHOST_VERSION=0.10.0
RUN wget -qO ghost.zip https://ghost.org/zip/ghost-${GHOST_VERSION}.zip && \
    rm -rf /var/www && \
    unzip ghost.zip -d /var/www/ && \
    rm -f ghost.zip && \
    cd /var/www && npm install --production

# Install PM2 for load balancing/uninterrupted service/stats/whathaveyou
RUN npm install pm2 -g



# Patch the rootfs
ADD ./overlay/ /


# Add ghost user
RUN useradd ghost && chown -R ghost:ghost /var/www


# Configures nginx
RUN ln -sf /etc/nginx/sites-available/ghost /etc/nginx/sites-enabled/ghost && \
    rm -f /etc/nginx/sites-enabled/default


# Clean rootfs from image-builder
RUN /usr/local/sbin/scw-builder-leave
