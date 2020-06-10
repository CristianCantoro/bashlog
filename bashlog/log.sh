#!/bin/bash
# shellcheck disable=SC2128,SC1090
SOURCED=false && [ "$0" = "$BASH_SOURCE" ] || SOURCED=true

if ! $SOURCED; then
	set -euo pipefail
	IFS=$'\n\t'
fi

# loglevels, shamelessly stolen from Pythons' logging module
# - 0: notset
# - 10: debug
# - 20: info
# - 30: warning
# - 40: error
# - 50: critical
# - 100: donotlog

#################### functions
function start_logging {
	local -a loglevels=('debug' 'info' 'warning' 'error' 'critical')
	local -A loglevels_map=(['notset']=0
													['debug']=10
													['info']=20
													['warning']=30
													['error']=40
													['critical']=50
													['donotlog']=100
													)

	local arg OPTIND OPTARG
	# optional args
	local format 
	local logger_loglevel logger_loglevel_val
	local verbosity verbosity_val
	format='"[" strftime("%Y-%m-%d %H:%M:%S") "][__loglevel__]:\t__msg__"'
	verbosity='notset'
	verbosity_val=0
	logger_loglevel='notset'
	logger_loglevel_val=0
	while getopts ':f:l:v:' arg; do
		case ${arg} in
			f) 	format="${OPTARG}";;
			l)	logger_loglevel="${OPTARG}";;
			v) 	verbosity="${OPTARG}";;
			*) return 1
		esac
	done

	# check logger_loglevel is admissibile 
	if test "${loglevels_map["$logger_loglevel"]+x}"; then
		logger_loglevel_val="${loglevels_map[$logger_loglevel]}"
	else
		(>&2 echo "[bashlog] logger loglevel '$logger_loglevel' not admissibile")
		return 2
	fi

	# check verbosity is admissibile 
	if test "${loglevels_map["$verbosity"]+x}"; then
		verbosity_val="${loglevels_map[$verbosity]}"
	else
		(>&2 echo "[bashlog] logger verbosity '$verbosity' not admissibile")
		return 3
	fi

	shift $((OPTIND-1))

	local logfile logger
	# positional args
	logfile="$1"
	logger="$2"

	mkdir -p "$(dirname "$logfile")"
	touch "$logfile"

	# log<message>
	local loglevel loglevel_val
	local logger_format
	for loglevel in "${loglevels[@]}"; do
		loglevel_val="${loglevels_map["$loglevel"]}"
		logger_format="${format/__loglevel__/$loglevel}"
		eval "$(cat <<-LOGGER
		function ${logger}_${loglevel} {
			if [ \$# -gt 0 ]; then

				# sed escape delimiter
				# https://stackoverflow.com/a/53412311/2377454
				if [ ${loglevel_val} -ge  ${verbosity_val} ]; then
					echo "\$1" | awk '{print $logger_format}' | \
					             sed "s/__msg__/\${1//\//\\\/}/g" \
						>> /dev/stderr
				fi

				if [ ${loglevel_val} -ge ${logger_loglevel_val} ]; then
					echo "\$1" | awk '{print $logger_format}' | \
					             sed "s/__msg__/\${1//\//\\\/}/g" \
						>> "$logfile"
				fi
			else
				local msg
				while read msg; do
					if [ ${loglevel_val} -ge  ${verbosity_val} ]; then
						echo "\$msg" | awk 'BEGIN	{ RS="(\r|\n)";
																				FS="";
																			}
															{
																printf $(printf '%s' "${logger_format/__msg__/%s}"),\$0;
																if (RT=="\r") {
																		printf "\r";
																} else {
																		printf "\n";
																}
															}' >> /dev/stderr
					fi

					if [ ${loglevel_val} -ge ${logger_loglevel_val} ]; then
						echo "\$msg" | awk 'BEGIN	{ RS="(\r|\n)";
																				FS="";
																			}
															{
																printf $(printf '%s' "${logger_format/__msg__/%s}"),\$0;
																if (RT=="\r") {
																		printf "\r";
																} else {
																		printf "\n";
																}
															}' >> "$logfile"
					fi
				done
			fi
			return 0
		}
		LOGGER
		)"
	done

	return 0
}
