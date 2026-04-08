FROM debian:bookworm-slim AS builder

ARG ARIA2_VERSION=release-1.37.0

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
    libuv1-dev \
    libcppunit-dev \
    zlib1g-dev \
    libzstd-dev \
    ca-certificates \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /aria2-build

RUN if [ "$ARIA2_VERSION" = "master" ]; then \
        git clone --depth 1 https://github.com/aria2/aria2.git aria2-src; \
        cd aria2-src; \
    else \
        curl -L -o aria2.tar.gz "https://github.com/aria2/aria2/releases/download/${ARIA2_VERSION}/aria2-${ARIA2_VERSION#release-}.tar.gz"; \
        tar xzf aria2.tar.gz; \
        rm aria2.tar.gz; \
        cd aria2-*; \
    fi

RUN cd aria2-* && \
    ./configure \
        --prefix=/usr/local \
        --enable-shared \
        --with-openssl \
        --with-libxml2 \
        --with-sqlite3 \
        --with-libuv \
        --enable-bittorrent \
        --enable-metalink \
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
    libuv1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /aria2-bin/ /usr/local/

ENV PATH="/usr/local:${PATH}"

RUN mkdir -p /config /downloads /etc/aria2

COPY aria2.conf /etc/aria2/aria2.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN aria2c --version

ENTRYPOINT ["/entrypoint.sh"]