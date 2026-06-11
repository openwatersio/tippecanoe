ARG TIPPECANOE_VERSION=2.79.0

# ---------------------------------------------------------------------------
# Builder
# ---------------------------------------------------------------------------
FROM debian:bookworm-slim AS builder

ARG TIPPECANOE_VERSION

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential libsqlite3-dev zlib1g-dev curl ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN curl -fsSL "https://github.com/felt/tippecanoe/archive/refs/tags/${TIPPECANOE_VERSION}.tar.gz" | tar xz \
  && cd tippecanoe-*/ \
  && make -j"$(nproc)" && make install

# ---------------------------------------------------------------------------
# Runtime
# ---------------------------------------------------------------------------
FROM debian:bookworm-slim

LABEL org.opencontainers.image.title="Tippecanoe" \
  org.opencontainers.image.description="Build vector tilesets from large collections of GeoJSON features (tippecanoe, tile-join, tippecanoe-decode, and friends)" \
  org.opencontainers.image.url="https://github.com/openwatersio/tippecanoe" \
  org.opencontainers.image.source="https://github.com/openwatersio/tippecanoe" \
  org.opencontainers.image.licenses="BSD-2-Clause"

RUN apt-get update && apt-get install -y --no-install-recommends \
  libsqlite3-0 zlib1g \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/tippecanoe* /usr/local/bin/tile-join /usr/local/bin/
COPY README.md /README.md

WORKDIR /data

CMD ["tippecanoe", "--help"]
