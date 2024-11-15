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

logfile1='test1.log'
logfile2='test2.log'

start_logging "$logfile1" 'logger1a'
start_logging -v 'debug' "$logfile1" 'logger1b'
start_logging -f '"(logfile2)[" strftime("%Y-%m-%d %H:%M:%S") "]: __msg__"' "$logfile2" 'logger2a'
start_logging -f '"(logfile2)[" strftime("%Y-%m-%d %H:%M:%S") "]: __msg__"' -v 'donotlog' "$logfile2" 'logger2b'

logger1a_debug 'test1a'
echo -e 'pipe line1\npipe line2' | logger1a_debug
logger1b_debug 'test1b'
echo -e 'pipe line3\npipe line4' | logger1b_debug

logger2a_debug 'test2a'
echo -e 'pipe line5\npipe line6' | logger2a_debug

logger2b_debug 'test2b'
echo -e 'pipe line7\npipe line8' | logger2b_debug

echo 'pipe line9a-' | logger1a_debug -n
echo 'pipe line9b-' | logger1a_debug -n
echo 'pipe line9c' | logger1a_debug

exit 0
