FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:longsleep/golang-backports

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    ca-certificates \
    debhelper \
    devscripts \
    dh-golang \
    libc6-dev-armhf-cross \
    gcc-arm-linux-gnueabihf \
    git \
    golang-go

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
