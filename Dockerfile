FROM alpine:latest

RUN apk --no-cache add mandoc \
    ca-certificates \
    autoconf \
    automake \
    build-base \
    glib \
    glib-dev \
    libc-dev \
    libtool \
    linux-headers \
    bison flex-dev unixodbc unixodbc-dev txt2man \
    unrar p7zip \
    git && \
        mkdir -p "/opt/mdbdata" && \
        cd /tmp && \
        git clone https://github.com/brianb/mdbtools.git && \
    cd mdbtools && \
    autoreconf -i -f && \
    ./configure --with-unixodbc=/usr/local --mandir=/usr/share/man && \
    make && make install && \
    rm -rf /tmp/mdbtools

WORKDIR /home/root

RUN apk add python3 curl && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py && rm -rf get-pip.py && python3 -m pip install typer