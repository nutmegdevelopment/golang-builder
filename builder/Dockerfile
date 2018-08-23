FROM golang:1.10.3-stretch

RUN apt-get update && apt-get install -y \
  libsystemd-dev \
  upx-ucl \
  && rm -rf /var/lib/apt/lists/*

# Install Docker binary
RUN wget -nv \
  https://get.docker.com/builds/Linux/x86_64/docker-1.9.0 -O /usr/bin/docker && \
  chmod +x /usr/bin/docker

RUN go get github.com/pwaller/goupx

WORKDIR /src

COPY build_environment.sh /
COPY build.sh /

ENTRYPOINT ["/build.sh"]
