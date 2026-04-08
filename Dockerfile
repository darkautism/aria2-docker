FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y \
    build-essential \
    autoconf \
    automake \
    autopoint \
    libtool \
    pkg-config \
    gettext \
    libssl-dev \
    libxml2-dev \
    libsqlite3-dev \
    libcppunit-dev \
    zlib1g-dev \
    libzstd-dev \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /aria2-build

RUN curl -L -o aria2.tar.gz "https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0.tar.gz" \
    && tar xzf aria2.tar.gz \
    && rm aria2.tar.gz

RUN cd aria2-1.37.0 && \
    ./configure \
        --prefix=/usr/local \
        --enable-shared \
        --with-openssl \
        --with-libxml2 \
        --without-libuv \
        --without-appletls \
        --without-gnutls \
        --disable-debug \
    && make -j$(nproc) \
    && make install \
    && ldconfig

RUN mkdir -p /aria2-bin && \
    cp /usr/local/bin/aria2c /aria2-bin/ && \
    cp /usr/local/lib/libaria2.so* /aria2-bin/ || true

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl3 \
    libxml2 \
    libsqlite3-0 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /aria2-bin/ /usr/local/

ENV PATH="/usr/local:${PATH}"

RUN aria2c --version

ENTRYPOINT ["aria2c"]
CMD ["--help"]