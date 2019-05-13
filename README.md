# Convert html-to-pdf via dockerized chrome headless

Because currently the `--print-to-pdf` CLI switch does not allow disabling of
header/footer the approach uses a nodejs script which connects to chrome via
remote interface. It also executes 5s of javascript (virtual time) to ensure
that the page is fully rendered.

## How to run it?

You need to mount a container workdir locally to be able to get the output file.

The workdir is `/tmp/html-to-pdf`, thus running:

```
docker run -v `pwd`:/tmp/html-to-pdf pink33n/html-to-pdf --url http://google.com --pdf out.pdf
```

Will produce `out.pdf` file in your current directory.

For all of the commandline arguments please check out the documentation for the library doing the actual heavy lifting:
[chrome-headless-render](https://github.com/Szpadel/chrome-headless-render-pdf).

## Privileged mode

The chrome sandbox is disabled automatically via `--chrome-option=--no-sandbox` switch so you *don't have to use* the `--privileged` mode when running the container anymore. 

## Version tags

The container versioning scheme is `${MAJOR_CHROME_VERSION}.${CONTAINER_VERSION}`

## Ansible

[ansible-html-to-pdf](https://github.com/pinkeen/ansible-html-to-pdf)
