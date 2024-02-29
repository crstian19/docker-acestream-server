FROM debian:10-slim
LABEL maintainer="Crstian19"

ARG DEBIAN_FRONTEND="noninteractive"

# install packages
RUN apt-get update && apt-get --yes upgrade

RUN apt-get --no-install-recommends --yes install \
	wget \
	libpython2.7 \
	net-tools \
	python-apsw \
	python-lxml \
	python-m2crypto \
	python-pkg-resources \
	python-pip \
	python-setuptools \
	build-essential \
	ca-certificates

# clean up
RUN apt-get clean && \
	rm --force --recursive /var/lib/apt/lists

RUN pip install  uv

#adding python modules
RUN uv pip install requests \
	pycryptodome \
	isodate

COPY .env ./
# install server
ARG ACE_STREAM_VERSION=3.1.74_debian_10.5
ENV ACE_STREAM_VERSION "$ACE_STREAM_VERSION"

RUN echo "Building AceStream: $ACE_STREAM_VERSION"

RUN wget -O - https://download.acestream.media/linux/acestream_${ACE_STREAM_VERSION}_x86_64.tar.gz | tar -xz -C /

EXPOSE 6878/tcp

ENTRYPOINT ["/start-engine"]
CMD ["--client-console", "@/acestream.conf"]