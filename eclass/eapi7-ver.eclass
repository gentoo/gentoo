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

# @FUNCTION: ver_test
# @USAGE: [<v1>] <op> <v2>
# @DESCRIPTION:
# Check if the relation <v1> <op> <v2> is true.  If <v1> is not specified,
# default to ${PVR}.  <op> can be -gt, -ge, -eq, -ne, -le, -lt.
# Both versions must conform to the PMS version syntax (with optional
# revision parts), and the comparison is performed according to
# the algorithm specified in the PMS.
ver_test() {
	local v1 v2 op i tail result
	local -a v1comp v2comp
	local match=(
		"+([0-9])*(.+([0-9]))"						# numeric components
		"[a-z]"										# letter component
		"*(@(_alpha|_beta|_pre|_rc|_p)*([0-9]))"	# suffixes
		"-r+([0-9])"								# revision
	)

	local LC_ALL=C shopt_save=$(shopt -p extglob)
	shopt -s extglob

	if [[ $# -eq 2 ]]; then
		v1=${PVR}
	elif [[ $# -eq 3 ]]; then
		v1=$1; shift
	else
		die "${FUNCNAME}: bad number of arguments"
	fi
	op=$1
	v2=$2

	case ${op} in
		-eq|-ne|-lt|-le|-gt|-ge) ;;
		*) die "${FUNCNAME}: invalid operator: ${op}" ;;
	esac

	# Test for both versions being valid, and split them into parts
	for (( i=0; i<4; i++ )); do
		tail=${v1##${match[i]}}
		v1comp[i]=${v1%"${tail}"}
		v1=${tail}
		tail=${v2##${match[i]}}
		v2comp[i]=${v2%"${tail}"}
		v2=${tail}
	done
	# There must not be any remaining tail, and the numeric part
	# must be non-empty.  All other parts are optional.
	[[ -z ${v1} && -z ${v2} && -n ${v1comp[0]} && -n ${v2comp[0]} ]] \
		|| die "${FUNCNAME}: invalid version"

	# Compare numeric components (PMS algorithm 3.2)
	_ver_cmp_num() {
		local a=(${1//./ }) b=(${2//./ })
		local an=${#a[@]} bn=${#b[@]}
		local i
		# First component
		[[ 10#${a[0]} -gt 10#${b[0]} ]] && return 2
		[[ 10#${a[0]} -lt 10#${b[0]} ]] && return 1
		for (( i=1; i<an && i<bn; i++ )); do
			# Other components (PMS algorithm 3.3)
			if [[ ${a[i]} == 0* || ${b[i]} == 0* ]]; then
				local ap=${a[i]%%*(0)} bp=${b[i]%%*(0)}
				[[ ${ap} > ${bp} ]] && return 2
				[[ ${ap} < ${bp} ]] && return 1
			else
				[[ ${a[i]} -gt ${b[i]} ]] && return 2
				[[ ${a[i]} -lt ${b[i]} ]] && return 1
			fi
		done
		[[ ${an} -gt ${bn} ]] && return 2
		[[ ${an} -lt ${bn} ]] && return 1
		return 0
	}

	# Compare letter components (PMS algorithm 3.4)
	_ver_cmp_let() {
		local a=$1 b=$2
		[[ ${a} > ${b} ]] && return 2
		[[ ${a} < ${b} ]] && return 1
		return 0
	}

	# Compare suffixes (PMS algorithm 3.5)
	_ver_cmp_suf() {
		local a=(${1//_/ }) b=(${2//_/ })
		local an=${#a[@]} bn=${#b[@]}
		local i
		for (( i=0; i<an && i<bn; i++ )); do
			# Compare each suffix (PMS algorithm 3.6)
			if [[ ${a[i]%%*([0-9])} == "${b[i]%%*([0-9])}" ]]; then
				[[ 10#${a[i]##*([a-z])} -gt 10#${b[i]##*([a-z])} ]] && return 2
				[[ 10#${a[i]##*([a-z])} -lt 10#${b[i]##*([a-z])} ]] && return 1
			else
				# Check for p first
				[[ ${a[i]} == p*([0-9]) ]] && return 2
				[[ ${b[i]} == p*([0-9]) ]] && return 1
				# Hack: Use that alpha < beta < pre < rc alphabetically
				[[ ${a[i]} > ${b[i]} ]] && return 2 || return 1
			fi
		done
		if [[ ${an} -gt ${bn} ]]; then
			[[ ${a[bn]} == p*([0-9]) ]] && return 2 || return 1
		elif [[ ${an} -lt ${bn} ]]; then
			[[ ${b[an]} == p*([0-9]) ]] && return 1 || return 2
		fi
		return 0
	}

	# Compare revision components (PMS algorithm 3.7)
	_ver_cmp_rev() {
		local a=${1#-r} b=${2#-r}
		[[ 10#${a} -gt 10#${b} ]] && return 2
		[[ 10#${a} -lt 10#${b} ]] && return 1
		return 0
	}

	# Version comparison top-level logic (PMS algorithm 3.1)
	_ver_cmp_num "${v1comp[0]}" "${v2comp[0]}" &&
	_ver_cmp_let "${v1comp[1]}" "${v2comp[1]}" &&
	_ver_cmp_suf "${v1comp[2]}" "${v2comp[2]}" &&
	_ver_cmp_rev "${v1comp[3]}" "${v2comp[3]}"

	case $? in
		0) result=0  ;;			# a = b
		1) result=-1 ;;			# a < b
		2) result=1  ;;			# a > b
		*) die "${FUNCNAME}: invalid return code: $?" ;;
	esac

	${shopt_save}

	test "${result}" "${op}" 0
}
