FROM alpine:3.1

COPY docker /usr/local/bin/docker

RUN mkdir /swarm-sec

COPY . /swarm-sec

WORKDIR /swarm-sec

ENTRYPOINT ["/bin/sh", "swarm-sec.sh"]
