# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: scons-utils.eclass
# @MAINTAINER:
# mgorny@gentoo.org
# @SUPPORTED_EAPIS: 7 8 9
# @BLURB: helper functions to deal with SCons buildsystem
# @DESCRIPTION:
# This eclass provides a set of function to help developers sanely call
# dev-build/scons and pass parameters to it.
#
# As of dev-build/scons-3.0.1-r100, SCons supports Python 3.  Since
# SCons* files in build systems are written as Python, all packages
# need to explicitly verify which versions of Python are supported
# and use appropriate Python suite eclass to select the implementation.
# The eclass needs to be inherited before scons-utils, and scons-utils
# will automatically take advantage of it. For more details, please see:
# https://projects.gentoo.org/python/guide/buildsys.html#scons
#
# Please note that SCons is more like a 'build system creation kit',
# and requires a lot of upstream customization to be used sanely.
# We attempt to force sane behavior via custom patching but this is not
# guaranteed to work. You will sometimes need to request fixes upstream
# and/or patch the build system. In particular, normally:
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
# PYTHON_COMPAT=( python3_{8..11} )
# inherit python-any-r1 scons-utils toolchain-funcs
#
# EAPI=8
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

# @ECLASS_VARIABLE: SCONS_MIN_VERSION
# @DEFAULT_UNSET
# @DESCRIPTION:
# The minimal version of SCons required for the build to work.
: "${SCONS_MIN_VERSION:=4.4.0}"

# @ECLASS_VARIABLE: SCONSOPTS
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# The default set of options to pass to scons. Similar to MAKEOPTS,
# supposed to be set in make.conf. If unset, escons() will set -j
# based on MAKEOPTS.

# @ECLASS_VARIABLE: EXTRA_ESCONS
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# The additional parameters to pass to SCons whenever escons() is used.
# Much like EXTRA_EMAKE, this is not supposed to be used in make.conf
# and not in ebuilds!

if [[ -z ${_SCONS_UTILS_ECLASS} ]]; then
_SCONS_UTILS_ECLASS=1

# -- EAPI support check --

case ${EAPI} in
	7|8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit multiprocessing

# -- ebuild variables setup --

SCONS_DEPEND=">=dev-build/scons-${SCONS_MIN_VERSION}"

if [[ ${_PYTHON_ANY_R1_ECLASS} ]]; then
	# when using python-any-r1, use any-of dep API
	BDEPEND="$(python_gen_any_dep "${SCONS_DEPEND}[\${PYTHON_USEDEP}]")"

	scons-utils_python_check_deps() {
		python_has_version "${SCONS_DEPEND}[${PYTHON_USEDEP}]"
	}
	python_check_deps() { scons-utils_python_check_deps; }
elif [[ ${_PYTHON_SINGLE_R1_ECLASS} ]]; then
	# when using python-single-r1, use PYTHON_USEDEP API
	BDEPEND="
		$(python_gen_cond_dep "${SCONS_DEPEND}[\${PYTHON_USEDEP}]")
		${PYTHON_DEPS}"
elif [[ ${_PYTHON_R1_ECLASS} ]]; then
	# when using python-r1, you need to depend on scons yourself
	# (depending on whether you need any-r1 or full -r1 API)
	# -- since this is a breaking API change, it applies to EAPI 7+ only
	BDEPEND=""
else
	# require appropriate eclass use
	eerror "Using scons-utils.eclass without any python-r1 suite eclass is not supported."
	eerror "Please make sure to configure and inherit appropriate -r1 eclass."
	eerror "For more information and examples, please see:"
	eerror "    https://wiki.gentoo.org/wiki/Project:Python/scons-utils_integration"
	die "Invalid use of scons-utils.eclass"
fi

# -- public functions --

# @FUNCTION: escons
# @USAGE: [<args>...]
# @DESCRIPTION:
# Call scons, passing the supplied arguments. Like emake, this function
# dies on failure, unless nonfatal is used.
escons() {
	local ret

	debug-print-function ${FUNCNAME} "$@"

	if [[ ! ${EPYTHON} ]]; then
		eerror "EPYTHON is unset while calling escons. This most likely means that"
		eerror "the ebuild did not call the appropriate eclass function before calling scons."
		if [[ ${_PYTHON_ANY_R1_ECLASS} ]]; then
			eerror "Please ensure that python-any-r1_pkg_setup is called in pkg_setup()."
		elif [[ ${_PYTHON_SINGLE_R1_ECLASS} ]]; then
			eerror "Please ensure that python-single-r1_pkg_setup is called in pkg_setup()."
		else # python-r1
			eerror "Please ensure that python_setup is called before escons, or that escons"
			eerror "is used within python_foreach_impl as appropriate."
		fi
		die "EPYTHON unset in escons"
	fi

	# if SCONSOPTS are unset, grab -j from MAKEOPTS
	: "${SCONSOPTS:=-j$(makeopts_jobs)}"

	# pass ebuild environment variables through!
	local -x GENTOO_SCONS_ENV_PASSTHROUGH=1

	set -- scons ${SCONSOPTS} ${EXTRA_ESCONS} "${@}"
	echo "${@}" >&2
	"${@}" || die -n "escons failed."
}

fi
