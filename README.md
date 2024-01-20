# Docker Ace Stream server

An [Ace Stream](http://www.acestream.org/) server Docker image.

- [Overview](#overview)
- [Building](#building)
- [Usage](#usage)
- [Reference](#reference)

## Overview

What this provides:

- Dockerized Ace Stream server (version `3.1.74`) running under Debian 10 (Buster) slim.
- Bash script to start server and present HTTP API endpoint to host.
- Python playback script [`playstream.py`](playstream.py) instructing server to:
	- Commence streaming of a given program ID.
	- ...and optionally start a compatible media player (such as [VLC](https://www.videolan.org/vlc/)) to view stream.

Since a single HTTP endpoint exposed from the Docker container controls the server _and_ provides the output stream, this provides one of the easier methods for playback of Ace Streams on traditionally unsupported operating systems such as macOS.


## Docker compose

``` yaml

version: "3.8"

services:
  acestream-server:
    container_name: acestream-server
    image: ghcr.io/crstian19/docker-acestream-server:main
    restart: always
    ports:
      - "6878:6878"
    volumes:
      - ./acestream.conf:/acestream.conf


```
## Building

To build Docker image:

```sh
$ docker compose build
```

To run Docker image:

```sh
$ docker compose up -d
```

Alternatively pull the Docker Hub image:

```sh
$ docker pull [todo]
```

## Usage

Start the server via:

```sh
$ ./run.sh
```

For Linux hosts the alternative [`run-tmpfs.sh`](run-tmpfs.sh) is recommended, mounting the cache directory into a [temporary based `tmpfs`](run-tmpfs.sh#L12) file system. This saves thrashing of the file system as stream contents is written to disk - which does not seem possible to disable via server launch arguments.

Server will now be available from `http://127.0.0.1:6878`:

```sh
$ curl http://127.0.0.1:6878/webui/api/service?method=get_version
# {"result": {"code": 3017400, "platform": "linux", "version": "3.1.74"}, "error": null}
```

A program ID can be started with [`playstream.py`](playstream.py):

```sh
$ ./playstream.py --help
usage: playstream.py [-h] --ace-stream-pid HASH [--player PLAYER] [--progress]
                     [--server HOSTNAME] [--port PORT]

Instructs server to commence a given program ID. Will optionally execute a
local media player once playback has started.

optional arguments:
  -h, --help            show this help message and exit
  --ace-stream-pid HASH
                        program ID to stream
  --player PLAYER       media player to execute once stream active
  --progress            continue to output stream statistics (connected
                        peers/transfer rates) every 2 seconds
  --server HOSTNAME     server hostname, defaults to 127.0.0.1
  --port PORT           server HTTP API port, defaults to 6878
```

For example, to stream `PROGRAM_ID` and send playback to `vlc` when ready:

```sh
$ ./playstream.py \
	--ace-stream-pid PROGRAM_ID \
	--player /usr/bin/vlc \
	--progress

Awaiting successful connection to stream
Waiting... [Peers: 5 // Down: 80KB // Up: 0KB]
Waiting... [Peers: 40 // Down: 343KB // Up: 4KB]
Ready!

Playback available at [http://127.0.0.1/XXXX]
Starting media player...

Streaming... [Peers: 18 // Down: 467KB // Up: 16KB]
```

Send <kbd>Ctrl + C</kbd> to exit.

## Reference

- Binary downloads: https://wiki.acestream.org/Download
- Ubuntu install notes: https://wiki.acestream.org/Install_Ubuntu
- HTTP API usage: https://wiki.acestream.org/Engine_HTTP_API
- `playstream.py` routines inspired by: https://github.com/jonian/acestream-launcher
