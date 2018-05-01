ARG DEBIAN_VERSION=jessie
FROM resin/armv7hf-debian:$DEBIAN_VERSION

# User, home (app) and data folders
ENV USER mongodb
ENV DATA /data

# User and group ID, for pi normally 1000
ARG UID=1000
ARG GID=1000

# Extra options to mongod like --journal --smallfiles
ARG MONGOD_EXTRA_OPTIONS
ENV MONGOD_EXTRA_OPTIONS $MONGOD_EXTRA_OPTIONS

RUN apt-get -qq update && \
    apt-get -qq upgrade && \
    apt-get -q install mongodb && \
    rm -rf /var/lib/apt/lists/* && \
# Adjust user and group ID
    usermod -u $UID $USER && \
    groupmod -g $GID $USER && \
# Prepare data folder
    mkdir $DATA/db -p && \
    cp /etc/mongodb.conf $DATA && \
    chown -R $USER:$USER $DATA && \
    chown -R $USER:$USER /var/log/mongodb

WORKDIR $DATA

EXPOSE 27017

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh", "/usr/bin/mongod", "--config", "/data/mongodb.conf", "--dbpath", "/data/db"]
# ENTRYPOINT ["/entrypoint.sh"]

USER $USER

CMD ["--smallfiles"]
# CMD ["sh", "-c", "exec /usr/bin/mongod --config /data/mongodb.conf --dbpath /data/db $MONGOD_EXTRA_OPTIONS"]

