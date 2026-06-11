#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:-tippecanoe:test}"

docker run --rm "$IMAGE" sh -c '
  pass=0
  fail=0

  run_test() {
    name="$1"; shift
    printf "%-40s" "$name"
    if "$@" >/dev/null 2>&1; then
      echo "PASS"
      pass=$((pass + 1))
      return
    fi
    echo "FAIL"
    fail=$((fail + 1))
  }

  {
    echo "{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-122.4,37.8]},\"properties\":{\"name\":\"test\"}}"
    echo "{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-122.5,37.9]},\"properties\":{\"name\":\"test2\"}}"
  } > /tmp/in.geojson

  run_test "tippecanoe prints version" \
    sh -c "tippecanoe --version 2>&1 | grep -q tippecanoe"

  run_test "tippecanoe builds mbtiles" \
    sh -c "tippecanoe -o /tmp/out.mbtiles -zg /tmp/in.geojson && test -s /tmp/out.mbtiles"

  run_test "tippecanoe builds pmtiles" \
    sh -c "tippecanoe -o /tmp/out.pmtiles -zg /tmp/in.geojson && test -s /tmp/out.pmtiles"

  run_test "tippecanoe-decode reads tileset" \
    sh -c "tippecanoe-decode /tmp/out.mbtiles | grep -q test"

  run_test "tile-join merges tilesets" \
    sh -c "tile-join -o /tmp/joined.mbtiles /tmp/out.mbtiles && test -s /tmp/joined.mbtiles"

  run_test "tippecanoe-json-tool runs" \
    sh -c "tippecanoe-json-tool /tmp/in.geojson | grep -q test"

  [ "$fail" -eq 0 ]
'
