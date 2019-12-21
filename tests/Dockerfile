FROM alpine:3.11.0

RUN apk add --update make vim bash

WORKDIR /ws
ADD GNUmakefile ./
ADD plugin plugin
ADD tests tests

ENTRYPOINT ["make", "tests"]
