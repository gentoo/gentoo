# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: scons-utils.eclass
# @MAINTAINER:
# mgorny@gentoo.org
# @BLURB: helper functions to deal with SCons buildsystem
# @DESCRIPTION:
# This eclass provides a set of function to help developers sanely call
# dev-util/scons and pass parameters to it.
#
# Please note that SCons is more like a 'build system creation kit',
# and requires a lot of upstream customization to be used sanely.
# You will often need to request fixes upstream and/or patch the build
# system. In particular:
#
# 1. There are no 'standard' variables. To respect CC, CXX, CFLAGS,
# CXXFLAGS, CPPFLAGS, LDFLAGS, upstream needs to define appropriate
# variables explicitly. In some cases, upstreams respect envvars,
# in others you need to pass them as options.
#
# 2. SCons scrubs out environment by default and replaces it with some
# pre-defined values. To respect environment variables such as PATH,
# Upstreams need to explicitly get them from os.environ and copy them
# to the build environment.
#
# @EXAMPLE:
# @CODE
# inherit scons-utils toolchain-funcs
#
# EAPI=5
#
# src_configure() {
# 	MYSCONS=(
# 		CC="$(tc-getCC)"
#		ENABLE_NLS=$(usex nls)
# 	)
# }
#
# src_compile() {
# 	escons "${MYSCONS[@]}"
# }
#
# src_install() {
# 	# note: this can be DESTDIR, INSTALL_ROOT, ... depending on package
# 	escons "${MYSCONS[@]}" DESTDIR="${D}" install
# }
# @CODE

# -- public variables --

# @ECLASS-VARIABLE: SCONS_MIN_VERSION
# @DEFAULT_UNSET
# @DESCRIPTION:
# The minimal version of SCons required for the build to work.

# @VARIABLE: myesconsargs
# @DEFAULT_UNSET
# @DESCRIPTION:
# DEPRECATED, EAPI 0..5 ONLY: pass options to escons instead
#
# List of package-specific options to pass to all SCons calls. Supposed to be
# set in src_configure().

# @ECLASS-VARIABLE: SCONSOPTS
# @DEFAULT_UNSET
# @DESCRIPTION:
# The default set of options to pass to scons. Similar to MAKEOPTS,
# supposed to be set in make.conf. If unset, escons() will use cleaned
# up MAKEOPTS instead.

# @ECLASS-VARIABLE: EXTRA_ESCONS
# @DEFAULT_UNSET
# @DESCRIPTION:
# The additional parameters to pass to SCons whenever escons() is used.
# Much like EXTRA_EMAKE, this is not supposed to be used in make.conf
# and not in ebuilds!

# @ECLASS-VARIABLE: USE_SCONS_TRUE
# @DESCRIPTION:
# DEPRECATED: use usex instead
#
# The default value for truth in scons-use() (1 by default).
: ${USE_SCONS_TRUE:=1}

# @ECLASS-VARIABLE: USE_SCONS_FALSE
# @DESCRIPTION:
# DEPRECATED: use usex instead
#
# The default value for false in scons-use() (0 by default).
: ${USE_SCONS_FALSE:=0}

# -- EAPI support check --

case ${EAPI:-0} in
	0|1|2|3|4|5|6) ;;
	*) die "EAPI ${EAPI} unsupported."
esac

# -- ebuild variables setup --

if [[ -n ${SCONS_MIN_VERSION} ]]; then
	DEPEND=">=dev-util/scons-${SCONS_MIN_VERSION}"
else
	DEPEND="dev-util/scons"
fi

# -- public functions --

# @FUNCTION: escons
# @USAGE: [<args>...]
# @DESCRIPTION:
# Call scons, passing the supplied arguments. Like emake, this function
# does die on failure in EAPI 4. Respects nonfatal in EAPI 6 and newer.
escons() {
	local ret

	debug-print-function ${FUNCNAME} "${@}"

	# Use myesconsargs in EAPI 5 and older
	if [[ ${EAPI} == [012345] ]]; then
		set -- "${myesconsargs[@]}" "${@}"
	fi

	# if SCONSOPTS are _unset_, use cleaned MAKEOPTS
	if [[ ! ${SCONSOPTS+set} ]]; then
		local SCONSOPTS
		_scons_clean_makeopts
	fi

	set -- scons ${SCONSOPTS} ${EXTRA_ESCONS} "${@}"
	echo "${@}" >&2
	"${@}"
	ret=${?}

	if [[ ${ret} -ne 0 ]]; then
		case "${EAPI:-0}" in
			0|1|2|3) # nonfatal in EAPIs 0 through 3
				;;
			4|5) # 100% fatal in 4 & 5
				die "escons failed."
				;;
			*) # respect nonfatal in 6 onwards
				die -n "escons failed."
				;;
		esac
	fi
	return ${ret}
}

# @FUNCTION: _scons_get_default_jobs
# @INTERNAL
# @DESCRIPTION:
# Output the default number of jobs, used if -j is used without
# argument. Tries to figure out the number of logical CPUs, falling
# back to hardcoded constant.
_scons_get_default_jobs() {
	local nproc

	if type -P nproc &>/dev/null; then
		# GNU
		nproc=$(nproc)
	elif type -P python &>/dev/null; then
		# fallback to python2.6+
		# note: this may fail (raise NotImplementedError)
		nproc=$(python -c 'import multiprocessing; print(multiprocessing.cpu_count());' 2>/dev/null)
	fi

	if [[ ${nproc} ]]; then
		echo $(( nproc + 1 ))
	else
		# random default
		echo 5
	fi
}

# @FUNCTION: _scons_clean_makeopts
# @INTERNAL
# @USAGE: [makeflags] [...]
# @DESCRIPTION:
# Strip the supplied makeflags (or ${MAKEOPTS} if called without
# an argument) of options not supported by SCons and make sure --jobs
# gets an argument. Output the resulting flag list (suitable
# for an assignment to SCONSOPTS).
_scons_clean_makeopts() {
	local new_makeopts=()

	debug-print-function ${FUNCNAME} "${@}"

	if [[ ${#} -eq 0 ]]; then
		debug-print "Using MAKEOPTS: [${MAKEOPTS}]"
		set -- ${MAKEOPTS}
	else
		# unquote if necessary
		set -- ${*}
	fi

	# empty MAKEOPTS give out empty SCONSOPTS
	# thus, we do need to worry about the initial setup
	if [[ ${*} = ${_SCONS_CACHE_MAKEOPTS} ]]; then
		SCONSOPTS=${_SCONS_CACHE_SCONSOPTS}
		debug-print "Cache hit: [${SCONSOPTS}]"
		return
	fi
	_SCONS_CACHE_MAKEOPTS=${*}

	while [[ ${#} -gt 0 ]]; do
		case ${1} in
			# clean, simple to check -- we like that
			--jobs=*|--keep-going)
				new_makeopts+=( ${1} )
				;;
			# need to take a look at the next arg and guess
			--jobs)
				if [[ ${#} -gt 1 && ${2} =~ ^[0-9]+$ ]]; then
					new_makeopts+=( ${1} ${2} )
					shift
				else
					# no value means no limit, let's pass a random int
					new_makeopts+=( ${1}=$(_scons_get_default_jobs) )
				fi
				;;
			# strip other long options
			--*)
				;;
			# short option hell
			-*)
				local str new_optstr
				new_optstr=
				str=${1#-}

				while [[ -n ${str} ]]; do
					case ${str} in
						k*)
							new_optstr+=k
							;;
						# -j needs to come last
						j)
							if [[ ${#} -gt 1 && ${2} =~ ^[0-9]+$ ]]; then
								new_optstr+="j ${2}"
								shift
							else
								new_optstr+="j $(_scons_get_default_jobs)"
							fi
							;;
						# otherwise, everything after -j is treated as an arg
						j*)
							new_optstr+=${str}
							break
							;;
					esac
					str=${str#?}
				done

				if [[ -n ${new_optstr} ]]; then
					new_makeopts+=( -${new_optstr} )
				fi
				;;
		esac
		shift
	done

	SCONSOPTS=${new_makeopts[*]}
	_SCONS_CACHE_SCONSOPTS=${SCONSOPTS}
	debug-print "New SCONSOPTS: [${SCONSOPTS}]"
}

# @FUNCTION: use_scons
# @USAGE: <use-flag> [var-name] [var-opt-true] [var-opt-false]
# @DESCRIPTION:
# DEPRECATED, EAPI 0..5 ONLY: use usex instead
#
# Output a SCons parameter with value depending on the USE flag state.
# If the USE flag is set, output <var-name>=<var-opt-true>; otherwise
# <var-name>=<var-opt-false>.
#
# If <var-name> is omitted, <use-flag> will be used instead. However,
# if <use-flag> starts with an exclamation mark (!flag), 'no' will be
# prepended to the name (e.g. noflag).
#
# If <var-opt-true> and/or <var-opt-false> are omitted,
# ${USE_SCONS_TRUE} and/or ${USE_SCONS_FALSE} will be used instead.
use_scons() {
	[[ ${EAPI} == [012345] ]] \
		|| die "${FUNCNAME} is banned in EAPI ${EAPI}, use usex instead"

	local flag=${1}
	local varname=${2:-${flag/\!/no}}
	local vartrue=${3:-${USE_SCONS_TRUE}}
	local varfalse=${4:-${USE_SCONS_FALSE}}

	debug-print-function ${FUNCNAME} "${@}"

	if [[ ${#} -eq 0 ]]; then
		eerror "Usage: scons-use <use-flag> [var-name] [var-opt-true] [var-opt-false]"
		die 'scons-use(): not enough arguments'
	fi

	if use "${flag}"; then
		echo "${varname}=${vartrue}"
	else
		echo "${varname}=${varfalse}"
	fi
}
