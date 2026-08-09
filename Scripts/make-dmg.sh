#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

derived="build/derived"
staging=$(mktemp -d)
scratch=$(mktemp -d)
trap 'rm -rf "$staging" "$scratch"' EXIT

mkdir -p "$derived"

version=()

if [ -n "${RELEASE_TAG:-}" ]; then
    read -r short build <<< "$(Scripts/version.sh "$RELEASE_TAG")"
    version=("MARKETING_VERSION=$short" "CURRENT_PROJECT_VERSION=$build")
    echo "building $short ($build) from $RELEASE_TAG"
fi

xcodebuild build \
    -project Nocturne.xcodeproj \
    -scheme Nocturne \
    -configuration Release \
    -derivedDataPath "$derived" \
    ${version[@]+"${version[@]}"} \
    >/dev/null

app="$derived/Build/Products/Release/Nocturne.app"

rm -rf build/Nocturne.app
cp -R "$app" build/Nocturne.app

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
