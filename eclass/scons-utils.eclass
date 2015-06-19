# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/scons-utils.eclass,v 1.11 2012/09/27 16:35:42 axs Exp $

# @ECLASS: scons-utils.eclass
# @MAINTAINER:
# mgorny@gentoo.org
# @BLURB: helper functions to deal with SCons buildsystem
# @DESCRIPTION:
# This eclass provides a set of function to help developers sanely call
# dev-util/scons and pass parameters to it.
# @EXAMPLE:
#
# @CODE
# inherit scons-utils toolchain-funcs
#
# EAPI=4
#
# src_configure() {
# 	myesconsargs=(
# 		CC="$(tc-getCC)"
# 		$(use_scons nls ENABLE_NLS)
# 	)
# }
#
# src_compile() {
# 	escons
# }
#
# src_install() {
# 	# note: this can be DESTDIR, INSTALL_ROOT, ... depending on package
# 	escons DESTDIR="${D}" install
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
# The default value for truth in scons-use() (1 by default).
: ${USE_SCONS_TRUE:=1}

# @ECLASS-VARIABLE: USE_SCONS_FALSE
# @DESCRIPTION:
# The default value for false in scons-use() (0 by default).
: ${USE_SCONS_FALSE:=0}

# -- EAPI support check --

case ${EAPI:-0} in
	0|1|2|3|4|5) ;;
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
# @USAGE: [scons-arg] ...
# @DESCRIPTION:
# Call scons, passing the supplied arguments, ${myesconsargs[@]},
# filtered ${MAKEOPTS}, ${EXTRA_ESCONS}. Similar to emake. Like emake,
# this function does die on failure in EAPI 4 (unless called nonfatal).
escons() {
	local ret

	debug-print-function ${FUNCNAME} "${@}"

	# if SCONSOPTS are _unset_, use cleaned MAKEOPTS
	set -- scons ${SCONSOPTS-$(scons_clean_makeopts)} ${EXTRA_ESCONS} \
		"${myesconsargs[@]}" "${@}"
	echo "${@}" >&2
	"${@}"
	ret=${?}

	[[ ${ret} -ne 0 ]] && has "${EAPI:-0}" 4 5 && die "escons failed."
	return ${ret}
}

# @FUNCTION: scons_clean_makeopts
# @USAGE: [makeflags] [...]
# @DESCRIPTION:
# Strip the supplied makeflags (or ${MAKEOPTS} if called without
# an argument) of options not supported by SCons and make sure --jobs
# gets an argument. Output the resulting flag list (suitable
# for an assignment to SCONSOPTS).
scons_clean_makeopts() {
	local new_makeopts

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
		set -- ${_SCONS_CACHE_SCONSOPTS}
		debug-print "Cache hit: [${*}]"
		echo ${*}
		return
	fi
	export _SCONS_CACHE_MAKEOPTS=${*}

	while [[ ${#} -gt 0 ]]; do
		case ${1} in
			# clean, simple to check -- we like that
			--jobs=*|--keep-going)
				new_makeopts=${new_makeopts+${new_makeopts} }${1}
				;;
			# need to take a look at the next arg and guess
			--jobs)
				if [[ ${#} -gt 1 && ${2} =~ ^[0-9]+$ ]]; then
					new_makeopts="${new_makeopts+${new_makeopts} }${1} ${2}"
					shift
				else
					# no value means no limit, let's pass a random int
					new_makeopts=${new_makeopts+${new_makeopts} }${1}=5
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
							new_optstr=${new_optstr}k
							;;
						# -j needs to come last
						j)
							if [[ ${#} -gt 1 && ${2} =~ ^[0-9]+$ ]]; then
								new_optstr="${new_optstr}j ${2}"
								shift
							else
								new_optstr="${new_optstr}j 5"
							fi
							;;
						# otherwise, everything after -j is treated as an arg
						j*)
							new_optstr=${new_optstr}${str}
							break
							;;
					esac
					str=${str#?}
				done

				if [[ -n ${new_optstr} ]]; then
					new_makeopts=${new_makeopts+${new_makeopts} }-${new_optstr}
				fi
				;;
		esac
		shift
	done

	set -- ${new_makeopts}
	export _SCONS_CACHE_SCONSOPTS=${*}
	debug-print "New SCONSOPTS: [${*}]"
	echo ${*}
}

# @FUNCTION: use_scons
# @USAGE: <use-flag> [var-name] [var-opt-true] [var-opt-false]
# @DESCRIPTION:
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
