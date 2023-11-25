# Please refer to `devenv.sh` for run instructions.

FROM alpine:latest

ARG ARG_USER
ARG ARG_UID
ARG ARG_GID

RUN apk update

RUN apk add bash
RUN apk add gradle

RUN apk add git vim

RUN addgroup -g ${ARG_GID} ${ARG_USER} || \
    echo "Group ${ARG_GID} already exists, OK if the group is 999, and when run by a Github action, suspicious otherwise."

RUN adduser -D -u ${ARG_UID} -G ${ARG_USER} ${ARG_USER} || \
    (adduser -D -u ${ARG_UID} ${ARG_USER} && \
     echo "The 'adduser: unknown group runner' error is OK when run by Github action runner.")

RUN mkdir -p /usr/local/bin
RUN echo -e '#!/bin/bash\ngradle clean' >/usr/local/bin/c
RUN echo -e '#!/bin/bash\ngradle build -x test' >/usr/local/bin/b
RUN echo -e '#!/bin/bash\ngradle run -q' >/usr/local/bin/r
RUN echo -e '#!/bin/bash\ngradle test -q -Dtestlogger.logLevel=quiet --rerun' >/usr/local/bin/t
RUN chmod +x /usr/local/bin/c
RUN chmod +x /usr/local/bin/b
RUN chmod +x /usr/local/bin/r
RUN chmod +x /usr/local/bin/t

USER ${ARG_USER}
WORKDIR /home/${ARG_USER}

ENV PS1='\[\033[01;35m\]{gradle-devenv}\033[00m\] \w \$ '

ENTRYPOINT ["/bin/bash"]
