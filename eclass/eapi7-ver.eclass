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
# aimed for EAPI 7.  Intended to be used for wider testing of
# the proposed functions and to allow ebuilds to switch to the new
# model early, with minimal change needed for actual EAPI 7.
#
# https://bugs.gentoo.org/482170
#
# @ROFF .SS
# Version strings
#
# The functions support arbitrary version strings consisting of version
# components interspersed with (possibly empty) version separators.
#
# A version component can either consist purely of digits ([0-9]+)
# or purely of uppercase and lowercase letters ([A-Za-z]+).  A version
# separator is either a string of any other characters ([^A-Za-z0-9]+),
# or it occurs at the transition between a sequence of letters
# and a sequence of digits, or vice versa.  In the latter case,
# the version separator is an empty string.
#
# The version is processed left-to-right, and each successive component
# is assigned numbers starting with 1.  The components are either split
# on version separators or on boundaries between digits and letters
# (in which case the separator between the components is empty).
# Version separators are assigned numbers starting with 1 for
# the separator between 1st and 2nd components.  As a special case,
# if the version string starts with a separator, it is assigned index 0.
#
# Examples:
#
# @CODE
#   1.2b-alpha4 -> 1 . 2 '' b - alpha '' 4
#                  c s c s  c s c     s  c
#                  1 1 2 2  3 3 4     4  5
#
#   .11.        -> . 11 .
#                  s c  s
#                  0 1  1
# @CODE
#
# @ROFF .SS
# Ranges
#
# A range can be specified as 'm' for m-th version component, 'm-'
# for all components starting with m-th or 'm-n' for components starting
# at m-th and ending at n-th (inclusive).  If the range spans outside
# the version string, it is truncated silently.

case ${EAPI:-0} in
	0|1|2|3|4|5)
		die "${ECLASS}: EAPI=${EAPI:-0} not supported";;
	6)
		;;
	*)
		die "${ECLASS}: EAPI=${EAPI} unknown";;
esac

# @FUNCTION: _ver_parse_range
# @USAGE: <range> <max>
# @INTERNAL
# @DESCRIPTION:
# Parse the range string <range>, setting 'start' and 'end' variables
# to the appropriate bounds.  <max> specifies the appropriate upper
# bound for the range; the user-specified value is truncated to this.
_ver_parse_range() {
	local range=${1}
	local max=${2}

	[[ ${range} == [0-9]* ]] \
		|| die "${FUNCNAME}: range must start with a number"
	start=${range%-*}
	[[ ${range} == *-* ]] && end=${range#*-} || end=${start}
	if [[ ${end} ]]; then
		[[ ${start} -le ${end} ]] \
			|| die "${FUNCNAME}: end of range must be >= start"
		[[ ${end} -le ${max} ]] || end=${max}
	else
		end=${max}
	fi
}

# @FUNCTION: _ver_split
# @USAGE: <version>
# @INTERNAL
# @DESCRIPTION:
# Split the version string <version> into separator-component array.
# Sets 'comp' to an array of the form: ( s_0 c_1 s_1 c_2 s_2 c_3... )
# where s_i are separators and c_i are components.
_ver_split() {
	local v=${1} LC_ALL=C

	comp=()

	# get separators and components
	local s c
	while [[ ${v} ]]; do
		# cut the separator
		s=${v%%[a-zA-Z0-9]*}
		v=${v:${#s}}
		# cut the next component; it can be either digits or letters
		[[ ${v} == [0-9]* ]] && c=${v%%[^0-9]*} || c=${v%%[^a-zA-Z]*}
		v=${v:${#c}}

		comp+=( "${s}" "${c}" )
	done
}

# @FUNCTION: ver_cut
# @USAGE: <range> [<version>]
# @DESCRIPTION:
# Print the substring of the version string containing components
# defined by the <range> and the version separators between them.
# Processes <version> if specified, ${PV} otherwise.
#
# For the syntax of versions and ranges, please see the eclass
# description.
ver_cut() {
	local range=${1}
	local v=${2:-${PV}}
	local start end
	local -a comp

	_ver_split "${v}"
	local max=$((${#comp[@]}/2))
	_ver_parse_range "${range}" "${max}"

	local IFS=
	if [[ ${start} -gt 0 ]]; then
		start=$(( start*2 - 1 ))
	fi
	echo "${comp[*]:start:end*2-start}"
}

# @FUNCTION: ver_rs
# @USAGE: <range> <repl> [<range> <repl>...] [<version>]
# @DESCRIPTION:
# Print the version string after substituting the specified version
# separators at <range> with <repl> (string).  Multiple '<range> <repl>'
# pairs can be specified.  Processes <version> if specified,
# ${PV} otherwise.
#
# For the syntax of versions and ranges, please see the eclass
# description.
ver_rs() {
	local v
	(( ${#} & 1 )) && v=${@: -1} || v=${PV}
	local start end i
	local -a comp

	_ver_split "${v}"
	local max=$((${#comp[@]}/2 - 1))

	while [[ ${#} -ge 2 ]]; do
		_ver_parse_range "${1}" "${max}"
		for (( i = start*2; i <= end*2; i+=2 )); do
			[[ ${i} -eq 0 && -z ${comp[i]} ]] && continue
			comp[i]=${2}
		done
		shift 2
	done

	local IFS=
	echo "${comp[*]}"
}

# @FUNCTION: _ver_compare_int
# @USAGE: <a> <b>
# @RETURN: 0 if <a> -eq <b>, 1 if <a> -lt <b>, 3 if <a> -gt <b>
# @INTERNAL
# @DESCRIPTION:
# Compare two non-negative integers <a> and <b>, of arbitrary length.
# If <a> is equal to, less than, or greater than <b>, return 0, 1, or 3
# as exit status, respectively.
_ver_compare_int() {
	local a=$1 b=$2 d=$(( ${#1}-${#2} ))

	# Zero-pad to equal length if necessary.
	if [[ ${d} -gt 0 ]]; then
		printf -v b "%0${d}d%s" 0 "${b}"
	elif [[ ${d} -lt 0 ]]; then
		printf -v a "%0$(( -d ))d%s" 0 "${a}"
	fi

	[[ ${a} > ${b} ]] && return 3
	[[ ${a} == "${b}" ]]
}

# @FUNCTION: _ver_compare
# @USAGE: <va> <vb>
# @RETURN: 1 if <va> < <vb>, 2 if <va> = <vb>, 3 if <va> > <vb>
# @INTERNAL
# @DESCRIPTION:
# Compare two versions <va> and <vb>.  If <va> is less than, equal to,
# or greater than <vb>, return 1, 2, or 3 as exit status, respectively.
_ver_compare() {
	local va=${1} vb=${2} a an al as ar b bn bl bs br re LC_ALL=C

	re="^([0-9]+(\.[0-9]+)*)([a-z]?)((_(alpha|beta|pre|rc|p)[0-9]*)*)(-r[0-9]+)?$"

	[[ ${va} =~ ${re} ]] || die "${FUNCNAME}: invalid version: ${va}"
	an=${BASH_REMATCH[1]}
	al=${BASH_REMATCH[3]}
	as=${BASH_REMATCH[4]}
	ar=${BASH_REMATCH[7]}

	[[ ${vb} =~ ${re} ]] || die "${FUNCNAME}: invalid version: ${vb}"
	bn=${BASH_REMATCH[1]}
	bl=${BASH_REMATCH[3]}
	bs=${BASH_REMATCH[4]}
	br=${BASH_REMATCH[7]}

	# Compare numeric components (PMS algorithm 3.2)
	# First component
	_ver_compare_int "${an%%.*}" "${bn%%.*}" || return

	while [[ ${an} == *.* && ${bn} == *.* ]]; do
		# Other components (PMS algorithm 3.3)
		an=${an#*.}
		bn=${bn#*.}
		a=${an%%.*}
		b=${bn%%.*}
		if [[ ${a} == 0* || ${b} == 0* ]]; then
			# Remove any trailing zeros
			[[ ${a} =~ 0+$ ]] && a=${a%"${BASH_REMATCH[0]}"}
			[[ ${b} =~ 0+$ ]] && b=${b%"${BASH_REMATCH[0]}"}
			[[ ${a} > ${b} ]] && return 3
			[[ ${a} < ${b} ]] && return 1
		else
			_ver_compare_int "${a}" "${b}" || return
		fi
	done
	[[ ${an} == *.* ]] && return 3
	[[ ${bn} == *.* ]] && return 1

	# Compare letter components (PMS algorithm 3.4)
	[[ ${al} > ${bl} ]] && return 3
	[[ ${al} < ${bl} ]] && return 1

	# Compare suffixes (PMS algorithm 3.5)
	as=${as#_}${as:+_}
	bs=${bs#_}${bs:+_}
	while [[ -n ${as} && -n ${bs} ]]; do
		# Compare each suffix (PMS algorithm 3.6)
		a=${as%%_*}
		b=${bs%%_*}
		if [[ ${a%%[0-9]*} == "${b%%[0-9]*}" ]]; then
			_ver_compare_int "${a##*[a-z]}" "${b##*[a-z]}" || return
		else
			# Check for p first
			[[ ${a%%[0-9]*} == p ]] && return 3
			[[ ${b%%[0-9]*} == p ]] && return 1
			# Hack: Use that alpha < beta < pre < rc alphabetically
			[[ ${a} > ${b} ]] && return 3 || return 1
		fi
		as=${as#*_}
		bs=${bs#*_}
	done
	if [[ -n ${as} ]]; then
		[[ ${as} == p[_0-9]* ]] && return 3 || return 1
	elif [[ -n ${bs} ]]; then
		[[ ${bs} == p[_0-9]* ]] && return 1 || return 3
	fi

	# Compare revision components (PMS algorithm 3.7)
	_ver_compare_int "${ar#-r}" "${br#-r}" || return

	return 2
}

# @FUNCTION: ver_test
# @USAGE: [<v1>] <op> <v2>
# @DESCRIPTION:
# Check if the relation <v1> <op> <v2> is true.  If <v1> is not specified,
# default to ${PVR}.  <op> can be -gt, -ge, -eq, -ne, -le, -lt.
# Both versions must conform to the PMS version syntax (with optional
# revision parts), and the comparison is performed according to
# the algorithm specified in the PMS.
ver_test() {
	local va op vb

	if [[ $# -eq 3 ]]; then
		va=${1}
		shift
	else
		va=${PVR}
	fi

	[[ $# -eq 2 ]] || die "${FUNCNAME}: bad number of arguments"

	op=${1}
	vb=${2}

	case ${op} in
		-eq|-ne|-lt|-le|-gt|-ge) ;;
		*) die "${FUNCNAME}: invalid operator: ${op}" ;;
	esac

	_ver_compare "${va}" "${vb}"
	test $? "${op}" 2
}
