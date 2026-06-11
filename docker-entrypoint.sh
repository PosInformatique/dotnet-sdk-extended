#!/usr/bin/env bash
set -e

# Load computed tool versions if present
if [ -f /etc/profile.d/tool-versions.sh ]; then
  # shellcheck disable=SC1091
  . /etc/profile.d/tool-versions.sh
fi

exec "$@"