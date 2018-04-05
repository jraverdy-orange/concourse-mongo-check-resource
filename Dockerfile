FROM alpine:edge
RUN apk add --update sed; \
    sed -e "/\/main$/!d" -e 's/\/main$/\/testing/' /etc/apk/repositories >> /etc/apk/repositories; \
    apk add --update perl perl-canary-stability perl-json perl-tie-ixhash curl
COPY /assets /opt/resource
