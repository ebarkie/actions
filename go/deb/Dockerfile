FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    ca-certificates \
    debhelper \
    dh-golang \
    libc6-dev-armhf-cross \
    gcc-arm-linux-gnueabihf \
    git \
    golang-go

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
