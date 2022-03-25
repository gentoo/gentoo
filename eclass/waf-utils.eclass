# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: waf-utils.eclass
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @AUTHOR:
# Original Author: Gilles Dartiguelongue <eva@gentoo.org>
# Various improvements based on cmake-utils.eclass: Tomáš Chvátal <scarabeus@gentoo.org>
# Proper prefix support: Jonathan Callen <jcallen@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: common ebuild functions for waf-based packages
# @DESCRIPTION:
# The waf-utils eclass contains functions that make creating ebuild for
# waf-based packages much easier.
# Its main features are support of common portage default settings.

inherit multilib toolchain-funcs multiprocessing

case ${EAPI:-0} in
	6|7) EXPORT_FUNCTIONS src_configure src_compile src_install ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

# @ECLASS_VARIABLE: WAF_VERBOSE
# @USER_VARIABLE
# @DESCRIPTION:
# Set to OFF to disable verbose messages during compilation
# this is _not_ meant to be set in ebuilds
: ${WAF_VERBOSE:=ON}

# @FUNCTION: waf-utils_src_configure
# @DESCRIPTION:
# General function for configuring with waf.
waf-utils_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	local fail
	if [[ ! ${_PYTHON_ANY_R1} && ! ${_PYTHON_SINGLE_R1} && ! ${_PYTHON_R1} ]]; then
		eerror "Using waf-utils.eclass without any python-r1 suite eclass is not supported."
		eerror "Please make sure to configure and inherit appropriate -r1 eclass."
		eerror "For more information and examples, please see:"
		eerror "    https://wiki.gentoo.org/wiki/Project:Python/waf-utils_integration"
		fail=1
	else
		if [[ ! ${EPYTHON} ]]; then
			eerror "EPYTHON is unset while calling waf-utils. This most likely means that"
			eerror "the ebuild did not call the appropriate eclass function before calling waf."
			if [[ ${_PYTHON_ANY_R1} ]]; then
				eerror "Please ensure that python-any-r1_pkg_setup is called in pkg_setup()."
			elif [[ ${_PYTHON_SINGLE_R1} ]]; then
				eerror "Please ensure that python-single-r1_pkg_setup is called in pkg_setup()."
			else # python-r1
				eerror "Please ensure that python_setup is called before waf-utils_src_configure(),"
				eerror "or that the latter is used within python_foreach_impl as appropriate."
			fi
			eerror
			fail=1
		fi

		if [[ ${PYTHON_REQ_USE} != *threads* ]]; then
			eerror "Waf requires threading support in Python. To accomodate this requirement,"
			eerror "please add 'threads(+)' to PYTHON_REQ_USE variable (above inherit line)."
			eerror "For more information and examples, please see:"
			eerror "    https://wiki.gentoo.org/wiki/Project:Python/waf-utils_integration"
			fail=1
		fi
	fi

	[[ ${fail} ]] && die "Invalid use of waf-utils.eclass"

	# @ECLASS_VARIABLE: WAF_BINARY
	# @DESCRIPTION:
	# Eclass can use different waf executable. Usually it is located in "${S}/waf".
	: ${WAF_BINARY:="${S}/waf"}

	local conf_args=()

	local waf_help=$("${WAF_BINARY}" --help 2>/dev/null)
	if [[ ${waf_help} == *--docdir* ]]; then
		conf_args+=( --docdir="${EPREFIX}"/usr/share/doc/${PF} )
	fi
	if [[ ${waf_help} == *--htmldir* ]]; then
		conf_args+=( --htmldir="${EPREFIX}"/usr/share/doc/${PF}/html )
	fi
	if [[ ${waf_help} == *--libdir* ]]; then
		conf_args+=( --libdir="${EPREFIX}/usr/$(get_libdir)" )
	fi

	tc-export AR CC CPP CXX RANLIB

	local CMD=(
		CCFLAGS="${CFLAGS}"
		LINKFLAGS="${CFLAGS} ${LDFLAGS}"
		PKGCONFIG="$(tc-getPKG_CONFIG)"
		"${WAF_BINARY}"
		"--prefix=${EPREFIX}/usr"
		"${conf_args[@]}"
		"${@}"
		configure
	)

	echo "${CMD[@]@Q}" >&2
	env "${CMD[@]}" || die "configure failed"
}

# @FUNCTION: waf-utils_src_compile
# @DESCRIPTION:
# General function for compiling with waf.
waf-utils_src_compile() {
	debug-print-function ${FUNCNAME} "$@"
	local _mywafconfig
	[[ ${WAF_VERBOSE} == ON ]] && _mywafconfig="--verbose"

	local jobs="--jobs=$(makeopts_jobs)"
	echo "\"${WAF_BINARY}\" build ${_mywafconfig} ${jobs} ${*}"
	"${WAF_BINARY}" ${_mywafconfig} ${jobs} "${@}" || die "build failed"
}

# @FUNCTION: waf-utils_src_install
# @DESCRIPTION:
# Function for installing the package.
waf-utils_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	echo "\"${WAF_BINARY}\" --destdir=\"${D}\" ${*} install"
	"${WAF_BINARY}" --destdir="${D}" "${@}" install  || die "Make install failed"

	# Manual document installation
	einstalldocs
}
