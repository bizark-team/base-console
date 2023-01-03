# syntax = docker/dockerfile:experimental
ARG USER_NAME="www"
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=etc/UTC
ARG TERM="xterm-256color"

FROM ubuntu:18.04
LABEL maintainer="Nick Fan <nickfan81@gmail.com>"
ARG DEBIAN_FRONTEND
ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND}
ARG TZ
ENV TZ=${TZ}
ARG USER_NAME
ENV USER_NAME=${USER_NAME}
ARG TERM
ENV TERM=${TERM}
ENV HOME /home/${USER_NAME}
ENV HOMEPATH /home/${USER_NAME}
SHELL ["/bin/bash", "-c"]

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    sudo net-tools iputils-ping iproute2 telnet curl wget httping nano procps traceroute iperf3 apt-transport-https ca-certificates software-properties-common redis-tools mysql-client
RUN addgroup ${USER_NAME} && adduser --gecos "" --ingroup ${USER_NAME} --disabled-password ${USER_NAME}
USER ${USER_NAME}
WORKDIR ${HOMEPATH}

USER root
RUN rm -rf /var/lib/apt/lists/*
RUN printf "%b" '#!'"/usr/bin/env sh\n \
    if [ \"\$1\" = \"daemon\" ];  then \n \
    tail -f /dev/null \n \
    else \n \
    exec \$@ \n \
    fi" >/entry.sh && chmod +x /entry.sh

USER ${USER_NAME}
ENTRYPOINT ["/entry.sh"]
CMD ["bash"]
