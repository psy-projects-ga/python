#!/usr/bin/env bash

function create_docker_container() {
  docker run \
    --name "python-build" \
    --detach \
    --volume "${PWD}:/root/data" \
    "ubuntu:24.04" \
    tail -f /dev/null

  docker container ls --all
}

create_docker_container
