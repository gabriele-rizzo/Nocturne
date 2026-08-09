#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

failures=0

expect() {
    local tag="$1" want="$2" got
    got=$(Scripts/version.sh "$tag")

    if [ "$got" != "$want" ]; then
        echo "$tag gave '$got', wanted '$want'" >&2
        failures=$((failures + 1))
    fi
}

reject() {
    if Scripts/version.sh "$1" >/dev/null 2>&1; then
        echo "$1 was accepted, should have been rejected" >&2
        failures=$((failures + 1))
    fi
}

expect v1.0 "1.0 10000"
expect v1.1.5 "1.1.5 10105"
expect v1.1.6 "1.1.6 10106"
expect v1.1.10 "1.1.10 10110"
expect v1.2.0 "1.2.0 10200"
expect v2.0.0 "2.0.0 20000"

reject latest
reject v1
reject v1.1.1.1
reject v1.0.100
reject ""

ordered=$(for tag in v1.0 v1.1.5 v1.1.6 v1.1.10 v1.2.0 v2.0.0; do
    Scripts/version.sh "$tag" | cut -d' ' -f2
done)

if ! printf '%s\n' "$ordered" | sort -c -n 2>/dev/null; then
    echo "build numbers are not strictly increasing across releases" >&2
    failures=$((failures + 1))
fi

if [ "$failures" -gt 0 ]; then
    echo "$failures version check(s) failed" >&2
    exit 1
fi

echo "version checks passed"
