#!/bin/bash

for ARG in "${@}"; do
	case ${ARG} in
		-jar)
			EXE=${2}
			shift 2
			break
			;;
		*)
			shift
			;;
	esac
done

if [[ ${EXE} != *.jar ]]; then
	echo "error: could not find jar argument in java invocation" >&2
	exit 1
fi

EXE=smcipmitool-${EXE%.jar}
EXE=${EXE,,}

exec "${EXE}" "${@}"
