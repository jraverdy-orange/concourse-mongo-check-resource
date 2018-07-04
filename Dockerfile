FROM alpine:edge
RUN  apk add --update perl perl-canary-stability perl-json curl python py-pip gcc
COPY /assets /opt/resource
