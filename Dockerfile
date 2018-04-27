FROM resin/armhf-alpine:edge

RUN apk --no-cache add && \
       python build-base \
       scons \
       python-dev libffi-dev openssl-dev

# COPY entrypoint.sh /
# ENTRYPOINT ["/entrypoint.sh"]
CMD ["sh"]

