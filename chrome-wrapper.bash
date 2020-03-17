#!/usr/bin/env bash

set -e

CMD="$(echo $CMD | sed -E 's/--no-sandbox|--disable-gpu|--headless|--disable-web-security|-–allow-file-access-from-files//gi')"
CMD="/usr/bin/chromium-browser --no-sandbox --headless --disable-gpu --disable-web-security -–allow-file-access-from-files $@"

echo "Running chrome using: $CMD"

$CMD