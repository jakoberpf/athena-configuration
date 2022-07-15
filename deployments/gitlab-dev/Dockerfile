FROM python:3.9-slim

ARG KUBECTL_VERSION=v1.17.0

RUN apt-get update && apt-get install -y curl

RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/)
    
RUN curl -sO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/${arch}/kubectl && \
    mv kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

ADD longhorn/requirements.txt .
RUN pip install -r requirements.txt

ADD ./longhorn /longhorn
WORKDIR /longhorn

ENTRYPOINT ["python handler.py"]