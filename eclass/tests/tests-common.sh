#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/tests/tests-common.sh,v 1.15 2015/05/11 17:34:39 ulm Exp $

if ! source /lib/gentoo/functions.sh ; then
	echo "Missing functions.sh.  Please install sys-apps/gentoo-functions!" 1>&2
	exit 1
fi

# Let overlays override this so they can add their own testsuites.
TESTS_ECLASS_SEARCH_PATHS=( .. )

inherit() {
	local e path
	for e in "$@" ; do
		for path in "${TESTS_ECLASS_SEARCH_PATHS[@]}" ; do
			local eclass=${path}/${e}.eclass
			if [[ -e "${eclass}" ]] ; then
				source "${eclass}"
				return 0
			fi
		done
	done
	die "could not find ${eclass}"
}
EXPORT_FUNCTIONS() { :; }

debug-print() {
	[[ ${#} -eq 0 ]] && return

	if [[ ${ECLASS_DEBUG_OUTPUT} == on ]]; then
		printf 'debug: %s\n' "${@}" >&2
	elif [[ -n ${ECLASS_DEBUG_OUTPUT} ]]; then
		printf 'debug: %s\n' "${@}" >> "${ECLASS_DEBUG_OUTPUT}"
	fi
}

debug-print-function() {
	debug-print "${1}, parameters: ${*:2}"
}

debug-print-section() {
	debug-print "now in section ${*}"
}

has() {
	local needle=$1
	shift

	local x
	for x in "$@"; do
		[ "${x}" = "${needle}" ] && return 0
	done
	return 1
}
use() { has "$1" ${IUSE} ; }

die() {
	echo "die: $*" 1>&2
	exit 1
}

has_version() {
	portageq has_version / "$@"
}

KV_major() {
	[[ -z $1 ]] && return 1

	local KV=$@
	echo "${KV%%.*}"
}

KV_minor() {
	[[ -z $1 ]] && return 1

	local KV=$@
	KV=${KV#*.}
	echo "${KV%%.*}"
}

KV_micro() {
	[[ -z $1 ]] && return 1

	local KV=$@
	KV=${KV#*.*.}
	echo "${KV%%[^[:digit:]]*}"
}

KV_to_int() {
	[[ -z $1 ]] && return 1

	local KV_MAJOR=$(KV_major "$1")
	local KV_MINOR=$(KV_minor "$1")
	local KV_MICRO=$(KV_micro "$1")
	local KV_int=$(( KV_MAJOR * 65536 + KV_MINOR * 256 + KV_MICRO ))

	# We make version 2.2.0 the minimum version we will handle as
	# a sanity check ... if its less, we fail ...
	if [[ ${KV_int} -ge 131584 ]] ; then
		echo "${KV_int}"
		return 0
	fi

	return 1
}

tret=0
tbegin() {
	ebegin "Testing $*"
}
texit() {
	rm -rf "${tmpdir}"
	exit ${tret}
}
tend() {
	t eend "$@"
}
t() {
	"$@"
	local ret=$?
	: $(( tret |= ${ret} ))
	return ${ret}
}

tmpdir="${PWD}/tmp"
pkg_root="${tmpdir}/$0/${RANDOM}"
T="${pkg_root}/temp"
D="${pkg_root}/image"
WORKDIR="${pkg_root}/work"
ED=${D}
mkdir -p "${D}" "${T}" "${WORKDIR}"

dodir() {
	mkdir -p "${@/#/${ED}/}"
}

elog() { einfo "$@" ; }

IUSE=""
CATEGORY="dev-eclass"
PN="tests"
PV="0"
P="${PN}-${PV}"
PF=${P}
SLOT=0
