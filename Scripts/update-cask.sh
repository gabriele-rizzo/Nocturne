#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

tag="${1:?usage: update-cask.sh <tag>}"
cask="Casks/nocturne.rb"

read -r short _ <<< "$(Scripts/version.sh "$tag")"

if [ ! -f Nocturne.dmg ]; then
    echo "Nocturne.dmg not found, run Scripts/make-dmg.sh first" >&2
    exit 1
fi

sha=$(shasum -a 256 Nocturne.dmg | cut -d' ' -f1)
patched=$(mktemp)
trap 'rm -f "$patched"' EXIT

sed -e "s|^  version \".*\"$|  version \"$short\"|" \
    -e "s|^  sha256 \".*\"$|  sha256 \"$sha\"|" \
    "$cask" > "$patched"

if ! grep -q "version \"$short\"" "$patched" || ! grep -q "sha256 \"$sha\"" "$patched"; then
    echo "cask did not take the new version or checksum" >&2
    exit 1
fi

cp "$patched" "$cask"

echo "cask -> $short $sha"
