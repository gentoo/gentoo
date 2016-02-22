#!/bin/bash

: ${PORTDIR:=/usr/portage}
: ${ECLASSDIR:=${0%/*}/../../../eclass}
: ${FILESDIR:=${ECLASSDIR}/../app-portage/eclass-manpages/files}

AWK="gawk"
while [[ $# -gt 0 ]] ; do
	case $1 in
	-e) ECLASSDIR=$2; shift;;
	-f) FILESDIR=$2; shift;;
	-d) AWK="dgawk";;
	*) break;;
	esac
	shift
done

if [[ ! -d ${ECLASSDIR} ]] ; then
	echo "Usage: ${0##*/} [-e eclassdir] [-f eclass-to-manpage.awk FILESDIR] [eclasses]" 1>&2
	exit 1
fi

[[ $# -eq 0 ]] && set -- "${ECLASSDIR}"/*.eclass

ret=0
for e in "$@" ; do
	set -- \
	${AWK} \
		-vECLASSDIR="${ECLASSDIR}" \
		-vPORTDIR="${PORTDIR}" \
		-f "${FILESDIR}"/eclass-to-manpage.awk \
		${e}
	if [[ ${AWK} == "gawk" ]] ; then
		"$@" > ${e##*/}.5
		tret=$?
		if [[ ${tret} -ne 0 ]] ; then
			rm -f ${e##*/}.5
			if [[ ${tret} -ne 77 ]] ; then
				echo "FAIL: ${e}"
				ret=1
			fi
		fi
	else
		"$@"
	fi
done
exit ${ret}
