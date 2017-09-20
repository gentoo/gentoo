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

# @FUNCTION: _ver_validate
# @USAGE: <comp[0]>...
# @DESCRIPTION:
# Verify that the version component array passed as the argument
# validates according to the PMS version rules. Returns 0 if it does,
# 1 otherwise.
_ver_validate() {
	local prev=start

	while [[ ${1} || ${2} ]]; do
		local s=${1}
		local c=${2}

		if [[ -z ${s} ]]; then
			if [[ ${c} == [0-9]* ]]; then
				# number without preceding sep may be either:
				case ${prev} in
					# a. 1st version number
					start) prev=numeric;;
					# b. _foo suffix number
					suffix) prev=suffix_num;;
					# c. -rN revision number
					revision) prev=revision_num;;
					*) return 1;;
				esac
			elif [[ -n ${c} ]]; then
				# letter without preceding sep = letter after version
				[[ ${prev} == numeric ]] || return 1
				[[ ${#c} -eq 1 ]] || return 1
				prev=letter
			fi
		elif [[ -z ${c} ]]; then
			# trailing suffix?
			return 1
		elif [[ ${s} == . ]]; then
			# number preceded by dot = numeric component
			[[ ${prev} == numeric ]] || return 1
		elif [[ ${s} == _ ]]; then
			# _ implies _foo suffix
			case ${prev} in
				numeric|letter|suffix|suffix_num) ;;
				*) return 1;;
			esac

			case ${c} in
				alpha) ;;
				beta) ;;
				rc) ;;
				pre) ;;
				p) ;;
				*) return 1;;
			esac
			prev=suffix
		elif [[ ${s} == - ]]; then
			# - implies revision
			case ${prev} in
				numeric|letter|suffix|suffix_num) ;;
				*) return 1;;
			esac

			[[ ${c} == r ]] || return 1
			prev=revision
		else
			return 1
		fi

		shift 2
	done

	# empty version string?
	[[ ${prev} != start ]] || return 1

	return 0
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
	local LC_ALL=C
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

	# explicitly strip -r0[00000...] to avoid overcomplexifying the algo
	[[ ${va} == *-r0* && 10#${va#*-r} -eq 0 ]] && va=${va%-r*}
	[[ ${vb} == *-r0* && 10#${vb#*-r} -eq 0 ]] && vb=${vb%-r*}

	local comp compb
	_ver_split "${vb}"
	compb=( "${comp[@]}" )
	_ver_split "${va}"

	_ver_validate "${comp[@]}" || die "${FUNCNAME}: invalid version: ${va}"
	_ver_validate "${compb[@]}" || die "${FUNCNAME}: invalid version: ${vb}"

	local i sa sb ca cb wa wb result=0
	for (( i = 0;; i += 2 )); do
		sa=${comp[i]}
		ca=${comp[i+1]}
		sb=${compb[i]}
		cb=${compb[i+1]}

		# 1. determine the component type for Ca
		if [[ -z ${sa} ]]; then
			if [[ ${ca} == [0-9]* ]]; then
				# number without preceding sep may be either:
				# a. 1st version number
				# b. _foo suffix number
				# c. -rN revision number
				# weight is irrelevant since (a) occurs simultaneously,
				# and (b)/(c) use weight of preceding component
				wa=0
				# method: plain numeric
				m=pn
			elif [[ -n ${ca} ]]; then
				# letter without preceding sep = letter after version
				# weight below numeric, lexical method
				wa=9
				m=l
			else
				# empty == end of version string
				# weight below all positive stuff but above negative
				wa=6
				m=
			fi
		elif [[ ${sa} == . ]]; then
			# number preceded by dot = numeric component
			# highest weight, weird PMS 2+ component comparison
			wa=10
			m=wn
		elif [[ ${sa} == _ ]]; then
			# _ implies _foo suffix
			# weights differ, comparison by weight
			case ${ca} in
				alpha) wa=2 ;;
				beta) wa=3 ;;
				rc) wa=4 ;;
				pre) wa=5 ;;
				p) wa=8 ;;
				*) die "Invalid version suffix: _${ca}";;
			esac
			m=
		elif [[ ${sa} == - ]]; then
			# - implies revision
			# weight below positive suffixes, no comparison
			[[ ${ca} == r ]] || die "Invalid version part: -${ca}"
			wa=7
			m=
		fi

		# 2. determine the component type for Cb
		if [[ -z ${sb} ]]; then
			if [[ ${cb} == [0-9]* ]]; then
				wb=0
			elif [[ -n ${cb} ]]; then
				wb=9
			else
				wb=6
			fi
		elif [[ ${sb} == . ]]; then
			wb=10
		elif [[ ${sb} == _ ]]; then
			case ${cb} in
				alpha) wb=2 ;;
				beta) wb=3 ;;
				rc) wb=4 ;;
				pre) wb=5 ;;
				p) wb=8 ;;
				*) die "Invalid version suffix: _${cb}";;
			esac
		elif [[ ${sb} == - ]]; then
			[[ ${cb} == r ]] || die "Invalid version part: -${cb}"
			wb=7
		fi

		# DEBUG
		#echo "$sa $ca [$wa] <$m> $sb $cb [$wb]" >&2

		# 3. compare weights, we can proceed further only if weights match
		if [[ ${wa} -ne ${wb} ]]; then
			result=$(( wa - wb ))
			break
		fi

		# 4. both empty maybe?
		[[ -z ${ca} && -z ${cb} ]] && break

		# 5. compare components according to the algo

		# weird numeric is weird and reuses pn/l, so do it first
		# (PMS algo 3.3)
		if [[ ${m} == wn ]]; then
			if [[ ${ca} != 0* && ${cb} != 0* ]]; then
				# if neither of them starts with 0, use normal numeric
				m=pn
			else
				# strip trailing zeros
				while [[ ${ca} == *0 ]]; do ca=${ca::-1}; done
				while [[ ${cb} == *0 ]]; do cb=${cb::-1}; done
				m=l
			fi
		fi

		case ${m} in
			pn) # plain numeric
				if [[ 10#${ca} -ne 10#${cb} ]]; then
					result=$(( 10#${ca} - 10#${cb} ))
					break
				fi
				;;
			l) # lexical
				if [[ ${ca} != ${cb} ]]; then
					[[ ${ca} > ${cb} ]] && result=1 || result=-1
					break
				fi
				;;
			'') ;;
			*) die "Unexpected comparison method m=${m}";;
		esac
	done

	test "${result}" "${op}" 0
}
