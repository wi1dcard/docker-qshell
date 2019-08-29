FROM golang:alpine AS build

ARG OS=linux
ARG ARCH=x64
ARG VERSION=v2.4.0
ARG EXT

ENV FILENAME qshell-${OS}-${ARCH}-${VERSION}${EXT}

RUN set -x \
    && apk add make git zip \
    && git clone --branch ${VERSION} https://github.com/qiniu/qshell.git \
    && cd qshell \
    && go get -v \
    && make all \
    && mv ${FILENAME} /qshell

FROM alpine

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
COPY --from=build /qshell /usr/bin/qshell
RUN chmod +x /usr/bin/qshell

CMD ["qshell"]
