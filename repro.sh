#!/usr/bin/env bash

# Reproduces pnpm 12.4.1 running an explicitly allowed postinstall script from
# a devDependency during `pnpm install --prod`.

set -euo pipefail

cd "$(dirname "$0")"

if [ "$(pnpm --version)" != "12.4.1" ]; then
  echo "This repro requires pnpm 12.4.1; found $(pnpm --version)." >&2
  exit 1
fi

rm -rf node_modules pnpm-lock.yaml dev-postinstall-ran

echo "Creating a frozen lockfile without running scripts..."
pnpm install --lockfile-only --ignore-scripts

echo
echo "Running the production-only install..."
pnpm install --prod --frozen-lockfile

echo
if [ ! -f dev-postinstall-ran ]; then
  echo "REPRODUCTION FAILED: the devDependency's postinstall did not run." >&2
  exit 1
fi

if find node_modules -path '*dev-postinstall-pkg*' -print -quit | grep -q .; then
  echo "REPRODUCTION FAILED: the devDependency was retained in production node_modules." >&2
  exit 1
fi

echo "BUG REPRODUCED: the devDependency's postinstall ran, but the package was omitted from production node_modules."
