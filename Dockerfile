ARG DEBIAN_VERSION=jessie
FROM debian:$DEBIAN_VERSION-slim

# User, home (app) and data folders
ARG DATA=/data
ARG USER=mongodb
ARG HOME=/home/$USER

# Runtime packages required
RUN apt-get update -qq && \
    apt-get install -y -qq \
      mongodb && \
    rm -rf /var/lib/apt/lists/*

# User and group ID, for pi normally 1000
ARG UID=1000
ARG GID=1000

# Adjust user and group ID
RUN usermod -u $UID $USER && \
    groupmod -g $GID $USER && \
# Prepare data folder
    mkdir $DATA/db -p && \
    cp /etc/mongodb.conf $DATA && \
    chown -R $USER:$USER $DATA && \
# Prepare log folder
    mkdir -p /var/log/$USER && \
    chown -R $USER:$USER /var/log/$USER

WORKDIR $DATA
USER $USER

EXPOSE 27017 28017

ENTRYPOINT ["/usr/bin/mongod", "--config", "/data/mongodb.conf", "--dbpath", "/data/db"]

CMD ["--smallfiles"]
