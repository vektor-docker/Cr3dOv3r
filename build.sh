#!/bin/bash -e

function build() {
    local release
    release="dry"
    doPull="yes"

    while getopts ":rph" opt; do
        case $opt in
            r)
                release="release"
                ;;
            p)
                doPull="no"
                ;;
            h)
                cat <<EOF
usage: build [OPTION]... [-- [docker build opts]]
  -h        show this help.
  -r        push resulting image.
  -p        don't pull base image.
EOF
                return 0;
                ;;
            :)
                echo "$0: option requires an argument -- '$OPTARG'" 1>&2
                return 1
                ;;
            *)
                echo "$0: invalid option -- '$OPTARG'" 1>&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    VERSION="1.0"
    DATE=$(date +"%Y-%m-%d")

    IMAGE_TAG="vektory79-docker-docker.bintray.io/vektory79/cr3dov3r"
    PROXY_ARGS="--build-arg http_proxy=${http_proxy} \
                --build-arg no_proxy=${no_proxy}"
    [ "${doPull}" == "yes" ] && docker pull javister-docker-docker.bintray.io/javister/javister-docker-base:1.0 || true
    [ "${doPull}" == "yes" ] && docker pull javister-docker-docker.bintray.io/javister/javister-docker-git:1.0 || true
    [ "${doPull}" == "yes" ] && docker pull javister-docker-docker.bintray.io/javister/javister-docker-python3:3.4 || true

    docker build \
        --build-arg DATE=${DATE} \
        --tag ${IMAGE_TAG}:latest \
        --tag ${IMAGE_TAG}:${VERSION} \
        --tag ${IMAGE_TAG}:${VERSION}-${DATE} \
        ${PROXY_ARGS} \
        $@ \
        .

    [ "${release}" == "release" ] && docker push ${IMAGE_TAG}:latest
    [ "${release}" == "release" ] && docker push ${IMAGE_TAG}:${VERSION}
    [ "${release}" == "release" ] && docker push ${IMAGE_TAG}:${VERSION}-${DATE}
}

trap "exit 1" INT TERM QUIT

build "$@"
