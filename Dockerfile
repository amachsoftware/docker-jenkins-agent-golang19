ARG GOLANG_VERSION=1.19

FROM golang:${GOLANG_VERSION} as gosrc
FROM jenkins/inbound-agent:latest

# Switch to root
USER root

# Installing basic packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y zip unzip curl jq && \
    apt-get clean && \
    rm -rf /tmp/*

ARG GO_BASE_PATH=/usr/local/go

COPY --from=gosrc ${GO_BASE_PATH} ${GO_BASE_PATH}
COPY --from=gosrc /go ${HOME}

ENV GOPATH=${HOME}
ENV PATH="${GOPATH}/bin:${GO_BASE_PATH}/bin:${PATH}"
ENV CGO_ENABLED=0

USER ${user}

ENTRYPOINT ["jenkins-agent"]
