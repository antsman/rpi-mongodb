FROM resin/armhf-alpine:edge

ARG MONGO_VERSION=3.2.19

# For Mozilla virtualenv: Exception: Could not detect environment shell!
ENV SHELL /bin/sh

RUN apk update && \
    apk --no-cache add \
        python scons \
        build-base wget python-dev libffi-dev openssl-dev perl linux-headers && \
    python --version && gcc --version && scons --version && \
# Get sources
    wget -N -q https://fastdl.mongodb.org/src/mongodb-src-r$MONGO_VERSION.tar.gz >/dev/null 2>&1 && \
    tar xf mongodb-src-r$MONGO_VERSION.tar.gz && \
    cd mongodb-src-r$MONGO_VERSION && \
# Generate additional sources
    cd src/third_party/mozjs-38/ && \
    ./get_sources.sh && \
    ./gen-config.sh arm linux && \
    cd -

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh"]

