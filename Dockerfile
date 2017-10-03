FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates dpkg fonts-liberation gconf-service libappindicator1 \
        libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 \
        libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 \
        libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 \
        libxrender1 libxss1 libxtst6 lsb-release wget xdg-utils curl bash \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb
RUN dpkg -i /tmp/chrome.deb && rm /tmp/chrome.deb

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get update && apt-get install -y --no-install-recommends nodejs
RUN npm install -g chrome-headless-render-pdf

RUN mkdir /tmp/html-to-pdf
WORKDIR /tmp/html-to-pdf

ENTRYPOINT ["/usr/bin/chrome-headless-render-pdf"]
