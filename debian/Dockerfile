FROM resin/armv7hf-debian:jessie

# User, home (app) and data folders
ENV USER mongodb
ENV DATA /data

# User and group ID, for pi normally 1000
ARG UID=1000
ARG GID=1000

# Extra options to mongod like --journal --smallfiles
ARG MONGOD_EXTRA_OPTIONS

RUN apt-get update && \
    apt-get upgrade && \
    apt-get install mongodb && \
    rm -rf /var/lib/apt/lists/* && \
# Adjust user and group ID
    usermod -u $UID $USER && \
    groupmod -g $GID $USER && \
# Prepare data folder
    mkdir $DATA/db -p && \
    cp /etc/mongodb.conf $DATA && \
    chown -R $USER:$USER $DATA

# WORKDIR $DATA

EXPOSE 27017

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/mongod", "--config", "/data/mongodb.conf", "--dbpath", "/data/db", "$MONGOD_EXTRA_OPTIONS"]

