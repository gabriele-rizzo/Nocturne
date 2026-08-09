#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

tag="${1:?usage: release-notes.sh <tag>}"

previous=$(git describe --tags --abbrev=0 --match 'v[0-9]*' "$tag^" 2>/dev/null || true)
range="$tag"

if [ -n "$previous" ]; then
    range="$previous..$tag"
fi

notes=$(git log --no-merges --format='%s' "$range" | grep -vE '^(Bump the version|Point the cask at)' || true)

if [ -z "$notes" ]; then
    notes="Maintenance and fixes."
fi

printf '%s\n' "$notes"
