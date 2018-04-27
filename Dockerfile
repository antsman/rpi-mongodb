FROM resin/armhf-alpine:edge

RUN apk update && \
    apk --no-cache add \
        python scons \
        build-base python-dev libffi-dev openssl-dev && \
    python --version && \
    gcc --version && \
    scons --version

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh"]

