# Convert html-to-pdf via dockerized chrome headless

Because currently the `--print-to-pdf` CLI switch does not allow disabling of
header/footer the approach uses a nodejs script which connects to chrome via
remote interface. It also executes 5s of javascript (virtual time) to ensure
that the page is fully rendered.

## BIG FAT WARNING - BREAKING CHANGES AHEAD!

If you came here because the container stopped working for you then
probably you were using the `latest` tag instead of the stable versioned
image.

The working directory has changed from `/tmp/html-to-pdf` to `/workspace`. It can
be changed via `WORKDIR` docker argument and environment variable of the same name.

Additionally Alpine is now used instead of Ubuntu what has reduced the image size
from ~800MB to ~100MB.

Also, there are a couple of additions: the built-in webserver, better logging
and all-over code remake.

## How to run it?

You need to mount the container's working directory (`/workspace`) locally
to be able to get the output file.

```
docker run -v "$(pwd):/workspace" pink33n/html-to-pdf --url http://google.com --pdf out.pdf
```

## Built-in static webserver

The `/workspace` directory is served on port 80, so you can render files from
the directory mounted to this volume by using `http://localhost/filename.html`.

## Chrome arguments

Chrome is started with these flags (beware, this may be unsecure in some rare circumstances!).

```
--no-sandbox --headless --disable-gpu --disable-web-security -–allow-file-access-from-files
```

This means that `file://` should also work, nevertheless, using the built-in web
server is recommended instead.

Also expired certificates should no longer be a problem and completely break
some of the functionality like before.

## Commandline arguments and the software that made this possible

For all of the commandline arguments please check out the documentation for the library doing the actual heavy lifting:

[chrome-headless-render](https://github.com/Szpadel/chrome-headless-render-pdf).


## Ansible

[ansible-html-to-pdf](https://github.com/pinkeen/ansible-html-to-pdf)
