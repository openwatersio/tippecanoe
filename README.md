# tippecanoe Docker image

Docker image for [tippecanoe](https://github.com/felt/tippecanoe), which builds vector tilesets from large collections of GeoJSON, FlatGeobuf, or CSV features. Includes `tippecanoe`, `tile-join`, `tippecanoe-decode`, `tippecanoe-enumerate`, `tippecanoe-json-tool`, and `tippecanoe-overzoom`, compiled from the latest release.

## Usage

The working directory inside the container is `/data`, so mount your data there:

```sh
# Build an mbtiles file from GeoJSON
docker run --rm -v "$PWD:/data" ghcr.io/openwatersio/tippecanoe \
  tippecanoe -o output.mbtiles -zg --drop-densest-as-needed input.geojson

# Build a PMTiles file directly
docker run --rm -v "$PWD:/data" ghcr.io/openwatersio/tippecanoe \
  tippecanoe -o output.pmtiles -zg input.geojson

# Merge tilesets
docker run --rm -v "$PWD:/data" ghcr.io/openwatersio/tippecanoe \
  tile-join -o merged.mbtiles a.mbtiles b.mbtiles

# Inspect a tileset
docker run --rm -v "$PWD:/data" ghcr.io/openwatersio/tippecanoe \
  tippecanoe-decode output.mbtiles 0 0 0
```

See the [tippecanoe documentation](https://github.com/felt/tippecanoe#readme) for all options.

## Images

Published to `ghcr.io/openwatersio/tippecanoe`.

Tags:

- `latest` — most recent build
- `2`, `2.79`, `2.79.0` — matching the upstream tippecanoe release

Multi-arch: `linux/amd64` and `linux/arm64`, built on native runners.

A daily workflow checks for new upstream releases and publishes them automatically. The image is also rebuilt monthly to pick up Debian base image security patches.

## Building Locally

```sh
docker build -t tippecanoe .
./test.sh tippecanoe
```
