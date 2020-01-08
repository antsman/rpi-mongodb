ARG DEBIAN_VERSION=buster
FROM debian:$DEBIAN_VERSION-slim as build

# Build packages required
RUN apt-get update -qq && \
    apt-get install -y -qq \
      build-essential \
      libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev \
      python-dev python-pip libssl-dev \
      libcurl4-openssl-dev glibc-source git curl wget python && \
    rm -rf /var/lib/apt/lists/*

ARG SRC=/usr/src

# Prepare src folder
RUN mkdir -p $SRC && \
    cd $SRC && \
# Get the code
    git clone https://github.com/mongodb/mongo.git && \
    ls -lh

WORKDIR $SRC/mongo

# Check out specific release
ARG RELEASE=r3.2.22
RUN git checkout $RELEASE && \
    git branch

# Generate additional sources
RUN cd src/third_party/mozjs-* && \
    ./get_sources.sh

RUN cd src/third_party/mozjs-* && \
    SHELL=/bin/bash ./gen-config.sh arm linux

# Build, database and shell
# https://koenaerts.ca/compile-and-install-mongodb-on-raspberry-pi/
# https://github.com/mongodb/mongo/wiki/Build-Mongodb-From-Source
# https://github.com/mongodb/mongo/blob/master/docs/building.md
RUN python buildscripts/scons.py mongod mongo --wiredtiger=off --mmapv1=on --disable-warnings-as-errors

# Strip debugging information
RUN ls -lh mongo* && \
    strip -s mongo* && \
    ls -lh mongo*

# Final stage
ARG DEBIAN_VERSION=buster
FROM debian:$DEBIAN_VERSION-slim

# User, home (app) and data folders
ARG DATA=/data
ARG USER=mongodb
ARG SRC=/usr/src
ARG HOME=/home/$USER

# Copy build result
COPY --from=build $SRC/mongo/mongo* /usr/bin/

# Runtime packages required
RUN apt-get update -qq && \
    apt-get install -y -qq \
      procps && \
    rm -rf /var/lib/apt/lists/*

# Prepare user, folders
RUN mkdir -p $DATA/db && \
# Add $USER user so we aren't running as root
    adduser -gecos '' --disabled-password $USER && \
    chown -R $USER:$USER $DATA && \
# Prepare log folder
    mkdir -p /var/log/$USER && \
    chown -R $USER:$USER /var/log/$USER

WORKDIR $HOME
USER $USER

EXPOSE 27017

ENTRYPOINT ["/usr/bin/mongod", "--config", "/data/mongodb.conf", "--dbpath", "/data/db"]

CMD ["--smallfiles"]
