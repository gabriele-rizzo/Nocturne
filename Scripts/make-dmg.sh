#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

derived=$(mktemp -d)
staging=$(mktemp -d)
scratch=$(mktemp -d)
trap 'rm -rf "$derived" "$staging" "$scratch"' EXIT

xcodebuild build \
    -project Nocturne.xcodeproj \
    -scheme Nocturne \
    -configuration Release \
    -derivedDataPath "$derived" \
    >/dev/null

app="$derived/Build/Products/Release/Nocturne.app"

cp -R "$app" "$staging/"
ln -s /Applications "$staging/Applications"
cp Scripts/VolumeIcon.icns "$staging/.VolumeIcon.icns"

hdiutil create \
    -volname Nocturne \
    -srcfolder "$staging" \
    -format UDRW \
    -quiet \
    "$scratch/rw.dmg"

mount=$(hdiutil attach -nobrowse -noverify "$scratch/rw.dmg" | grep -o '/Volumes/.*' | head -1)
SetFile -a C "$mount"
hdiutil detach "$mount" -quiet

rm -f Nocturne.dmg
hdiutil convert "$scratch/rw.dmg" -format UDZO -quiet -o Nocturne.dmg

echo "Nocturne.dmg  $(du -h Nocturne.dmg | cut -f1)"
