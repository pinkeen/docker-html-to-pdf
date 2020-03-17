#!/usr/bin/env bash

set -e

VER_STATIC="$(static --version | sed -E 's/.*static ([0-9\.]+).*/\1/gi')"
VER_CHROME="$(chromium-browser --version | sed -E 's/.*Chromium ([0-9a-z\.]+).*/\1/gi')"
VER_NODE="$(node --version | sed -E 's/.*v([0-9a-z\.]+).*/\1/gi')"
VER_RENDER="$(npm info chrome-headless-render-pdf .version)"

WORKDIR="${WORKDIR:-`pwd`}"

STATIC_PORT="${STATIC_PORT:-80}"
STATIC_ROOT="${STATIC_ROOT:-$WORKDIR}"

export SCRIPT_PID="$$"

trap "cleanup; exit 0" 10 EXIT SIGTERM SIGHUP
trap "cleanup; exit 1" 11

cleanup() {
    echo "---  Cleaning up..."

    [ -z "$(jobs -p)" ] || kill -9 `jobs -p` 2>/dev/null
}

fatal() {
    echo -e "\n---  FATAL: $@" >&2
    kill -11 $SCRIPT_PID
}

quit() {
    echo -e "\n---  Quitting..."
    kill -10 $SCRIPT_PID
}

info() {
    echo -e "\n----  Environment info\n"

    echo "Workdir: $WORKDIR"

    echo "Chrome: $VER_CHROME"
    echo "NodeJS: $VER_NODE"
    echo "Static: $VER_STATIC"
    echo "RenderPDF: $VER_RENDER"
}

serve() {
    echo -e "\n---  Starting static webserver\n"

    echo "Port: $STATIC_PORT"
    echo "Root: $STATIC_ROOT"

    static -p $STATIC_PORT "$STATIC_ROOT" | sed -E 's/^/[serve] > /g' &

    local PID=$!
    local WAIT=0

    until kill -0 $PID 2>/dev/null ; do
        (( WAIT>10 )) && fatal "Static webserver failed to start!"
        (( WAIT+=1 ))
        echo "---  Waiting for static webserver to start..."
        sleep 0.1s
    done
}

render() {
    local CMD="chrome-headless-render-pdf --chrome-binary=/usr/local/bin/chrome-wrapper $@"

    echo -e "\n---  Running render: $CMD \n"
    $CMD | sed -E 's/^/[render] > /g'
}

info
serve
render $@
quit

