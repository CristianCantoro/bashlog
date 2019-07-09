#!/bin/bash
# shellcheck disable=SC2128
SOURCED=false && [ "$0" = "$BASH_SOURCE" ] || SOURCED=true

if ! $SOURCED; then
  set -euo pipefail
  IFS=$'\n\t'
fi

#################### functions
# start_logging(newlogfile)
__log__start_logging_verbose=false
__log__start_logging_awkscript=$(cat <<'AWKSCRIPT'
BEGIN   { RS="(\r|\n)";
          FS="";
        }
{
    printf "[" strftime("%Y-%m-%d %H:%M:%S") "]: ";
    printf $0;
    if (RT=="\r") {
        printf "\r";
    } else {
        printf "\n";
    }
}
AWKSCRIPT
)
OLDIFS="$IFS"
IFS='' __log__start_logging_awkscript=$(echo "${__log__start_logging_awkscript}" \
                                             | tr '\t' ' ' \
                                             | tr '\n' ' ')
IFS="$OLDIFS"
function start_logging {
  __log__logfile="$1"

  mkdir -p "$(dirname "$__log__logfile")"
  touch "$__log__logfile"

  # if $3 is not provided, default is false
  if [ -z "${2+x}" ]; then
    __log__start_logging_verbose=false
  else
    __log__start_logging_verbose="$2"
  fi

  function log() {

    if ${__log__start_logging_verbose}; then
      echo "$1" | awk '{print "[" strftime("%Y-%m-%d %H:%M:%S") "]: " $0 }' | \
        tee -a "$__log__logfile"
    else
      echo "$1" | awk '{print "[" strftime("%Y-%m-%d %H:%M:%S") "]: " $0 }' \
        >> "$__log__logfile"
    fi

    return 0
  }

  function log_pipe() {
    stdbuf -o0 awk "$__log__start_logging_awkscript" -

    return 0
  }
}
