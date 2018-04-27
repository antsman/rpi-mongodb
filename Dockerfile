FROM resin/armhf-alpine:edge

RUN apk update && \
    apk --no-cache add \
        python \
        scons \
        build-base python-dev libffi-dev openssl-dev

# COPY entrypoint.sh /
# ENTRYPOINT ["/entrypoint.sh"]
CMD ["sh"]

