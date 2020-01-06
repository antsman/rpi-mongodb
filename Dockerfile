ARG DEBIAN_VERSION=stretch
FROM debian:$DEBIAN_VERSION-slim

# User, home (app) and data folders
ARG DATA=/data
ARG USER=mongodb
ARG HOME=/home/$USER

# Runtime packages required
RUN apt-get update -qq && \
    apt-get install -y -qq \
      wget gnupg procps && \
    rm -rf /var/lib/apt/lists/*

# Install MongoDB Community Edition
# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/
    # Import the MongoDB public GPG Key
RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add - &&\
    # Create a source list file for MongoDB
    echo "deb http://repo.mongodb.org/apt/debian $DEBIAN_VERSION/mongodb-org/4.2 main" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list && \
    # Reload local package database
    apt-get update -qq && \
    # Install the latest stable version
    apt-get install -y \
      mongodb-org && \
    rm -rf /var/lib/apt/lists/* && \
    # Pin the package at the currently installed version:
    echo "mongodb-org hold" | dpkg --set-selections && \
    echo "mongodb-org-shell hold" | dpkg --set-selections && \
    echo "mongodb-org-tools hold" | dpkg --set-selections && \
    echo "mongodb-org-server hold" | dpkg --set-selections && \
    echo "mongodb-org-mongos hold" | dpkg --set-selections

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
