#!/usr/bin/env bash

# shellcheck disable=SC2128
SOURCED=false && [ "$0" = "$BASH_SOURCE" ] || SOURCED=true

if ! $SOURCED; then
  set -euo pipefail
  IFS=$'\n\t'
fi

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1090
source "$scriptdir/../bashlog/log.sh"

# creates a logger called mylogger
start_logging 'test.log' 'mylogger'

# logs a message
mylogger_debug 'This is a DEBUG log message'
mylogger_info 'This is a INFO log message'

# logs the output of command
date | mylogger_info

exit 0
