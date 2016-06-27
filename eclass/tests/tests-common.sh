#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
