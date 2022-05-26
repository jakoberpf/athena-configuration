FROM alpine/k8s:1.22.6

RUN curl -fsSLO https://github.com/gitpod-io/gitpod/releases/latest/download/gitpod-installer-linux-amd64
RUN curl -fsSLO https://github.com/gitpod-io/gitpod/releases/latest/download/gitpod-installer-linux-amd64.sha256
# RUN ct gitpod-installer-linux-amd64.sha256 | sha256sum -c
RUN install -o root -g root gitpod-installer-linux-amd64 /usr/local/bin/gitpod-installer
