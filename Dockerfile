FROM alpine:3

RUN apk update \
    && apk add --no-cache \
      chromium \
      nodejs \
      npm \
      sed \
      bash \
      procps

RUN npm install -g \
      chrome-headless-render-pdf \
      node-static

COPY entrypoint.bash /usr/local/bin/entrypoint
COPY chrome-wrapper.bash /usr/local/bin/chrome-wrapper

RUN mkdir /tmp/html-to-pdf \
    && chmod +x /usr/local/bin/*

ARG WORKDIR="/workspace"
ENV WORKDIR="${WORKDIR}"

WORKDIR "${WORKDIR}"

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]