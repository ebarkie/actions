FROM golang:1.14

RUN apt-get update && apt-get install --no-install-recommends -y zip

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
