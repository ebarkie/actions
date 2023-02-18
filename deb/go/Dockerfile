FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y software-properties-common && \
    add-apt-repository -y ppa:longsleep/golang-backports

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    ca-certificates \
    debhelper \
    devscripts \
    dh-golang \
    libc6-dev-armhf-cross \
    libc6-dev-arm64-cross \
    gcc-arm-linux-gnueabihf \
    gcc-aarch64-linux-gnu \
    git \
    golang-go

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
