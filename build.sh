#!/bin/sh
export VERSION=1.0.0

echo Building https://github.com/jraverdy-orange/concourse-mongo-check-resource:${VERSION}

docker build --no-cache -t https://github.com/jraverdy-orange/concourse-mongo-check-resource:${VERSION} . --build-arg http_proxy=http://10.171.41.73:3128

echo Pushing last version on docker-hub
docker tag https://github.com/jraverdy-orange/concourse-mongo-check-resource:${VERSION} jraverdyorange/https://github.com/jraverdy-orange/concourse-mongo-check-resource:${VERSION}
docker tag jraverdyorange/https://github.com/jraverdy-orange/concourse-mongo-check-resource:${VERSION} jraverdyorange/https://github.com/jraverdy-orange/concourse-mongo-check-resource:latest
docker push jraverdyorange/https://github.com/jraverdy-orange/concourse-mongo-check-resource
