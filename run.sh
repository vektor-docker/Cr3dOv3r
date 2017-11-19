#!/bin/bash

## resolve links - $0 may be a link to ant's home
PRG="$0"

# need this for relative symlinks
while [ -h "$PRG" ] ; do
  ls="$(ls -ld "$PRG")"
  link="$(expr "$ls" : '.*-> \(.*\)$')"
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG="$(dirname "$PRG")/$link"
  fi
done

PROXY_ARGS="--env http_proxy=${http_proxy} \
            --env no_proxy=${no_proxy}"

docker run ${PROXY_ARGS} -e PUID=$(id -u) -e PGID=$(id -g) --rm -ti javister-docker-docker.bintray.io/vektory79/cr3dov3r:1.0 $@
