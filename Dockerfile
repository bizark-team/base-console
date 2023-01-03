# syntax = docker/dockerfile:experimental

FROM ubuntu:18.04
LABEL maintainer="Nick Fan <nickfan81@gmail.com>"
ENV HOME /home/www
ENV HOMEPATH /home/www

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    sudo net-tools iputils-ping iproute2 telnet curl wget httping nano procps traceroute iperf3 apt-transport-https ca-certificates software-properties-common
RUN addgroup www && adduser --gecos "" --ingroup www --disabled-password www
USER www
WORKDIR ${HOMEPATH}

USER root
RUN rm -rf /var/lib/apt/lists/*
RUN printf "%b" '#!'"/usr/bin/env sh\n \
    if [ \"\$1\" = \"daemon\" ];  then \n \
    tail -f /dev/null \n \
    else \n \
    exec \$@ \n \
    fi" >/entry.sh && chmod +x /entry.sh

USER www
ENTRYPOINT ["/entry.sh"]
CMD ["bash"]
