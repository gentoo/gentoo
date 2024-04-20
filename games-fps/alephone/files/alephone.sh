#!/usr/bin/env bash

DIR=$(dirname "${0}")
CMD=$(basename "${0}")
ALEPHONE=${CMD%%.sh}

if [[ -z "${1}" ]]
then
	echo "Usage: ${0} SCENARIO FLAGS"
	echo "Where SCENARIO is one of:"
	for d in @GENTOO_PORTAGE_EPREFIX@/usr/share/alephone-*
	do
		echo "  ${d##*/alephone-}"
	done
	exit 2
fi

DATA="@GENTOO_PORTAGE_EPREFIX@/usr/share/alephone-${1}"

shift

# kill ARTS, because we're just that nice
if artsshell terminate 2> /dev/null
then
	sleep 2
fi

"${DIR}"/"${ALEPHONE}" "$@" "${DATA}"
