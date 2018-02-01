FROM golang:1.9.3-stretch

RUN apt-get update && apt-get install -y libsystemd-dev

VOLUME /src
WORKDIR /src

COPY build_environment.sh /
COPY test.sh /

ENTRYPOINT ["/test.sh"]
