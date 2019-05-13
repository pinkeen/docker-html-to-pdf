FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y curl

RUN curl -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install -y 'google-chrome-stable=74.0.3729.131-1' && \
  rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get update && apt-get install -y --no-install-recommends nodejs
RUN npm install -g chrome-headless-render-pdf

RUN mkdir /tmp/html-to-pdf
WORKDIR /tmp/html-to-pdf

ENTRYPOINT ["/usr/bin/chrome-headless-render-pdf", "--chrome-option=--no-sandbox"]
