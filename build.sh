#!/bin/sh
export VERSION=1.0.0

echo Building concourse-mongo-check-resource:${VERSION}

docker build --no-cache -t concourse-mongo-check-resource:${VERSION} . --build-arg http_proxy=http://10.171.41.73:3128

echo Pushing last version on docker-hub
docker tag concourse-mongo-check-resource:${VERSION} jraverdyorange/concourse-mongo-check-resource:${VERSION}
docker tag jraverdyorange/concourse-mongo-check-resource:${VERSION} jraverdyorange/concourse-mongo-check-resource:latest
docker push jraverdyorange/concourse-mongo-check-resource
