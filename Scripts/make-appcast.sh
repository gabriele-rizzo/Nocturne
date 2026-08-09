#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

tag="${1:?usage: make-appcast.sh <tag>}"
app="build/Nocturne.app"
derived="build/derived"

if [ ! -d "$app" ]; then
    echo "$app not found, run Scripts/make-dmg.sh first" >&2
    exit 1
fi

sign=$(find "$derived/SourcePackages/artifacts" -name sign_update -type f | head -1)

if [ -z "$sign" ]; then
    echo "sign_update not found, resolve the Sparkle package first" >&2
    exit 1
fi

plist="$app/Contents/Info.plist"
short=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$plist")
build=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$plist")
minimum=$(/usr/libexec/PlistBuddy -c "Print :LSMinimumSystemVersion" "$plist")

rm -f Nocturne.zip
ditto -c -k --sequesterRsrc --keepParent "$app" Nocturne.zip

if [ -n "${SPARKLE_PRIVATE_KEY:-}" ]; then
    key=$(mktemp)
    trap 'rm -f "$key"' EXIT
    printf '%s' "$SPARKLE_PRIVATE_KEY" > "$key"
    signature=$("$sign" -f "$key" Nocturne.zip)
else
    signature=$("$sign" Nocturne.zip)
fi
url="https://github.com/gabriele-rizzo/Nocturne/releases/download/$tag/Nocturne.zip"
page="https://github.com/gabriele-rizzo/Nocturne/releases/tag/$tag"

previous=$(git describe --tags --abbrev=0 --match 'v[0-9]*' "$tag^" 2>/dev/null || true)
range="$tag"

if [ -n "$previous" ]; then
    range="$previous..$tag"
fi

notes=$(git log --no-merges --format='%s' "$range" | grep -v '^Bump the version' || true)

if [ -z "$notes" ]; then
    notes="Maintenance and fixes."
fi

items=$(printf '%s\n' "$notes" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' -e 's|.*|            <li>&</li>|')

cat > appcast.xml <<XML
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle">
    <channel>
        <title>Nocturne</title>
        <link>https://github.com/gabriele-rizzo/Nocturne</link>
        <description>Keyboard backlight scheduling for macOS.</description>
        <language>en</language>
        <item>
            <title>$short</title>
            <link>https://github.com/gabriele-rizzo/Nocturne/releases/tag/$tag</link>
            <sparkle:version>$build</sparkle:version>
            <sparkle:shortVersionString>$short</sparkle:shortVersionString>
            <sparkle:minimumSystemVersion>$minimum</sparkle:minimumSystemVersion>
            <description><![CDATA[
        <h3>Nocturne $short</h3>
        <ul>
$items
        </ul>
        <p><a href="$page">Full release notes</a></p>
        ]]></description>
            <pubDate>$(date -u "+%a, %d %b %Y %H:%M:%S +0000")</pubDate>
            <enclosure url="$url" type="application/octet-stream" $signature />
        </item>
    </channel>
</rss>
XML

echo "appcast.xml  $short ($build)"
