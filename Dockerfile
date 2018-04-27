FROM resin/armhf-alpine:edge

ENV MONGO_VERSION 3.2.19

RUN apk update && \
    apk --no-cache add \
        python scons \
        build-base wget python-dev libffi-dev openssl-dev && \
    python --version && \
    gcc --version && \
    scons --version && \
#   Get sources
    wget https://fastdl.mongodb.org/src/mongodb-src-r$MONGO_VERSION.tar.gz && \
    tar xf mongodb-src-r$MONGO_VERSION.tar.gz && \
    cd mongodb-src-r$MONGO_VERSION

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh"]
