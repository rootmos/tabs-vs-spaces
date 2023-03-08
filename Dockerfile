FROM alpine:3.17

RUN apk update
RUN apk add wget lua5.4 bash make coreutils neovim
ENV LUA=lua5.4

WORKDIR /repo
ADD plugin plugin
ADD lua lua
ADD tests tests

RUN tests/run -p

ENTRYPOINT ["tests/run", "-P"]
