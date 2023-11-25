#!/bin/bash
#
# Just `./devenv.sh` will start the dev environment.
#
# Alternatively, some `./devenv.sh -c 'gradle run'` runs a specific command.
# Be sure to `rm .devenv_docker_container_id` when altering the container.

set +e

ARG_USER=$(whoami)
ARG_UID=$(id -u)
ARG_GID=$(id -g)

CONTAINER_FN=.devenv_docker_container_id

ARGS="--build-arg ARG_USER=${ARG_USER} --build-arg ARG_UID=${ARG_UID} --build-arg ARG_GID=${ARG_GID}"

if [ -f "$CONTAINER_FN" ] ; then
  CANDIDATE_CONTAINER_ID="$(cat "$CONTAINER_FN")"
  if ! docker image inspect "$CANDIDATE_CONTAINER_ID" >/dev/null 2>&1 ; then
    echo 'The image provided in `'$CONTAINER_FN'` is not available. Rebuilding.'
  else
    CONTAINER_ID="$CANDIDATE_CONTAINER_ID"
  fi
fi

if [ "$CONTAINER_ID" == "" ] ; then
  DOCKER_BUILDKIT=1 docker build $ARGS .
  CONTAINER_ID=$(DOCKER_BUILDKIT=1 docker build -q $ARGS .)
  echo $CONTAINER_ID >"$CONTAINER_FN"
fi

INTERACTIVE_FLAG=$([ -t 0 ] && echo '-it' || echo '-i')

docker run -v "$PWD":/home/${ARG_USER} $INTERACTIVE_FLAG $CONTAINER_ID "$@"
