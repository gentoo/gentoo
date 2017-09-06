# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: eapi7-ver.eclass
# @MAINTAINER:
# PMS team <pms@gentoo.org>
# @AUTHOR:
# Ulrich Müller <ulm@gentoo.org>
# Michał Górny <mgorny@gentoo.org>
# @BLURB: Testing implementation of EAPI 7 version manipulators
# @DESCRIPTION:
# A stand-alone implementation of the version manipulation functions
# aimed for EAPI 7. Intended to be used for wider testing of
# the proposed functions and to allow ebuilds to switch to the new
# model early, with minimal change needed for actual EAPI 7.
#
# https://bugs.gentoo.org/482170
#
# Note: version comparison function is not included currently.

case ${EAPI:-0} in
	0|1|2|3|4|5)
		die "${ECLASS}: EAPI=${EAPI:-0} not supported";;
	6)
		;;
	*)
		die "${ECLASS}: EAPI=${EAPI} unknown";;
esac

_version_parse_range() {
	[[ $1 =~ ^([0-9]+)(-([0-9]*))?$ ]] || die
	start=${BASH_REMATCH[1]}
	[[ ${BASH_REMATCH[2]} ]] && end=${BASH_REMATCH[3]} || end=${start}
	[[ ${start} -gt 0 ]] && [[ -z ${end} || ${start} -le ${end} ]] || die
}

_version_split() {
	local v=$1 LC_ALL=C

	# get first component
	[[ ${v} =~ ^([A-Za-z]*|[0-9]*) ]] || die
	comp=("${BASH_REMATCH[1]}")
	v=${v:${#BASH_REMATCH[0]}}

	# get remaining separators and components
	while [[ ${v} ]]; do
		[[ ${v} =~ ^([^A-Za-z0-9]*)([A-Za-z]*|[0-9]*) ]] || die
		comp+=("${BASH_REMATCH[@]:1:2}")
		v=${v:${#BASH_REMATCH[0]}}
	done
}

version_cut() {
	local start end
	local -a comp

	_version_parse_range "$1"
	_version_split "${2-${PV}}"

	local IFS=
	if [[ ${end} ]]; then
		echo "${comp[*]:(start-1)*2:(end-start)*2+1}"
	else
		echo "${comp[*]:(start-1)*2}"
	fi
}

version_rs() {
	local start end i
	local -a comp

	(( $# & 1 )) && _version_split "${@: -1}" || _version_split "${PV}"

	while [[ $# -ge 2 ]]; do
		_version_parse_range "$1"
		[[ ${end} && ${end} -le $((${#comp[@]}/2)) ]] || end=$((${#comp[@]}/2))
		for (( i = start*2 - 1; i < end*2; i+=2 )); do
			comp[i]=$2
		done
		shift 2
	done

	local IFS=
	echo "${comp[*]}"
}
