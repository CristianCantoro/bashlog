#!/usr/bin/env bash

# shellcheck disable=SC2128
SOURCED=false && [ "$0" = "$BASH_SOURCE" ] || SOURCED=true

if ! $SOURCED; then
  set -euo pipefail
  IFS=$'\n\t'
fi

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1090
source "$scriptdir/bashlog/log.sh"

LOGFILE='test.log'

start_logging "$LOGFILE" true
log 'test'

echo 'pipe' | log_pipe | tee -a "$LOGFILE"

exit 0
