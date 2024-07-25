FROM ubuntu:24.04
LABEL maintainer="Crstian19"

# install packages
RUN apt-get update && apt-get --yes upgrade

RUN apt-get --no-install-recommends --yes install \
	wget \
	python3.10 \
	libpython3.10 \
	python3.10-distutils \
	net-tools \
	python3-pip \
	build-essential \
	libsqlite3-dev \
	libxml2-dev \
	libxslt1-dev \
	ca-certificates && \
	pip install uv

# clean up
RUN apt-get clean && \
	rm --force --recursive /var/lib/apt/lists

#RUN pip install uv

#adding python modules
RUN uv pip install --system requests \
	pycryptodome \
	lxml apsw PyNaCl \
	isodate


#RUN wget -O - https://download.acestream.media/linux/acestream_3.2.3_ubuntu_22.04_x86_64_py3.10.tar.gz | tar -xz -C /

RUN wget --progress=dot:giga "https://download.acestream.media/linux/acestream_3.2.3_ubuntu_22.04_x86_64_py3.10.tar.gz" && \
    mkdir acestream && \
    tar zxf "acestream_3.2.3_ubuntu_22.04_x86_64_py3.10.tar.gz" -C acestream && \
    mv acestream /opt/acestream

EXPOSE 6878/tcp

ENTRYPOINT ["/opt/acestream/start-engine"]
CMD ["--client-console", "@/acestream.conf"]

