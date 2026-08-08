#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

derived=$(mktemp -d)
staging=$(mktemp -d)
trap 'rm -rf "$derived" "$staging"' EXIT

xcodebuild build \
    -project Nocturne.xcodeproj \
    -scheme Nocturne \
    -configuration Release \
    -derivedDataPath "$derived" \
    >/dev/null

cp -R "$derived/Build/Products/Release/Nocturne.app" "$staging/"
ln -s /Applications "$staging/Applications"

rm -f Nocturne.dmg
hdiutil create \
    -volname Nocturne \
    -srcfolder "$staging" \
    -format UDZO \
    -quiet \
    Nocturne.dmg

echo "Nocturne.dmg  $(du -h Nocturne.dmg | cut -f1)"
