#!/bin/bash
set -euo pipefail

tag="${1:?usage: version.sh <tag>}"
short="${tag#v}"

if ! printf '%s' "$short" | grep -Eq '^[0-9]+\.[0-9]+(\.[0-9]+)?$'; then
    echo "tag $tag is not a version" >&2
    exit 1
fi

major="${short%%.*}"
rest="${short#*.}"
minor="${rest%%.*}"
patch=0

if [ "$rest" != "$minor" ]; then
    patch="${rest#*.}"
fi

if [ "$minor" -gt 99 ] || [ "$patch" -gt 99 ]; then
    echo "tag $tag has a component over 99, which would break build ordering" >&2
    exit 1
fi

echo "$short $((major * 10000 + minor * 100 + patch))"
