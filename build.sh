#!/bin/bash

set -e

VERSION=${1:?Usage: ./build.sh VERSION SERVER [SERVER..]}
shift
SERVER=${@:?Usage: ./build.sh VERSION SERVER [SERVER..]}

REPO=menski
IMAGE=i-woke-up-like-this

function is_minor_release {
    local IFS=.
    local version=($VERSION)
    [[ ${#version[@]} -lt 3 || ${version[2]} == 0* ]]
}

function can_build_ee {
    [[ -n "$CAMUNDA_USER" && -n "$CAMUNDA_PASSWORD" ]]
}

function build_ce {
    for server in $SERVER; do
        echo "Building Camunda $VERSION image for $server"
        docker build \
            --build-arg VERSION=${VERSION} \
            -t ${REPO}/${IMAGE}:${server}-${VERSION} -f ${server}/Dockerfile ${server}/
    done
}

function build_ee {
    version=${VERSION%-ee}-ee
    for server in $SERVER; do
        echo "Building Camunda $version image for $server"
        docker build \
            --build-arg NEXUS="https://${CAMUNDA_USER}:${CAMUNDA_PASSWORD}@app.camunda.com/nexus/service/local/artifact/maven/content" \
            --build-arg REPOSITORY=camunda-bpm-ee \
            --build-arg ARTIFACT=camunda-bpm-ee-${server} \
            --build-arg VERSION=${version} \
            -t ${REPO}/${IMAGE}:${server}-${version} -f ${server}/Dockerfile ${server}/
    done
}

if is_minor_release; then
    build_ce
fi


if can_build_ee; then
    build_ee
else
    echo "Skipping Camunda EE images. To build Camunda EE images please set the following enviroment variables:"
    echo "  CAMUNDA_USER      - your Camunda username to download artifacts"
    echo "  CAMUNDA_PASSWORD  - your Camunda password to download artifacts"
    is_minor_release
    exit $?
fi
