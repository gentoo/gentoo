# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: python-single-r1.eclass
# @MAINTAINER:
# Python team <python@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# Based on work of: Krzysztof Pawlik <nelchael@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7
# @BLURB: An eclass for Python packages not installed for multiple implementations.
# @DESCRIPTION:
# An extension of the python-r1 eclass suite for packages which
# don't support being installed for multiple Python implementations.
# This mostly includes tools embedding Python and packages using foreign
# build systems.
#
# This eclass sets correct IUSE.  It also provides PYTHON_DEPS
# and PYTHON_REQUIRED_USE that need to be added to appropriate ebuild
# metadata variables.
#
# The eclass exports PYTHON_SINGLE_USEDEP that is suitable for depending
# on other packages using the eclass.  Dependencies on packages using
# python-r1 should be created via python_gen_cond_dep() function,
# using PYTHON_USEDEP placeholder.
#
# Please note that packages support multiple Python implementations
# (using python-r1 eclass) can not depend on packages not supporting
# them (using this eclass).
#
# Please note that python-single-r1 will always inherit python-utils-r1
# as well. Thus, all the functions defined there can be used
# in the packages using python-single-r1, and there is no need ever
# to inherit both.
#
# For more information, please see the Python Guide:
# https://dev.gentoo.org/~mgorny/python-guide/

case "${EAPI:-0}" in
	0|1|2|3|4)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	5|6|7)
		# EAPI=5 is required for sane USE_EXPAND dependencies
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

if [[ ! ${_PYTHON_SINGLE_R1} ]]; then

if [[ ${_PYTHON_R1} ]]; then
	die 'python-single-r1.eclass can not be used with python-r1.eclass.'
elif [[ ${_PYTHON_ANY_R1} ]]; then
	die 'python-single-r1.eclass can not be used with python-any-r1.eclass.'
fi

inherit python-utils-r1

fi

EXPORT_FUNCTIONS pkg_setup

# @ECLASS-VARIABLE: PYTHON_COMPAT
# @REQUIRED
# @DESCRIPTION:
# This variable contains a list of Python implementations the package
# supports. It must be set before the `inherit' call. It has to be
# an array.
#
# Example:
# @CODE
# PYTHON_COMPAT=( python2_7 python3_3 python3_4 )
# @CODE
#
# Please note that you can also use bash brace expansion if you like:
# @CODE
# PYTHON_COMPAT=( python2_7 python3_{3,4} )
# @CODE

# @ECLASS-VARIABLE: PYTHON_COMPAT_OVERRIDE
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# This variable can be used when working with ebuilds to override
# the in-ebuild PYTHON_COMPAT. It is a string naming the implementation
# which package will be built for. It needs to be specified
# in the calling environment, and not in ebuilds.
#
# It should be noted that in order to preserve metadata immutability,
# PYTHON_COMPAT_OVERRIDE does not affect IUSE nor dependencies.
# The state of PYTHON_SINGLE_TARGET is ignored, and the implementation
# in PYTHON_COMPAT_OVERRIDE is built instead.  Dependencies need to be
# satisfied manually.
#
# Example:
# @CODE
# PYTHON_COMPAT_OVERRIDE='pypy' emerge -1v dev-python/bar
# @CODE

# @ECLASS-VARIABLE: PYTHON_REQ_USE
# @DEFAULT_UNSET
# @DESCRIPTION:
# The list of USEflags required to be enabled on the chosen Python
# implementations, formed as a USE-dependency string. It should be valid
# for all implementations in PYTHON_COMPAT, so it may be necessary to
# use USE defaults.
#
# This should be set before calling `inherit'.
#
# Example:
# @CODE
# PYTHON_REQ_USE="gdbm,ncurses(-)?"
# @CODE
#
# It will cause the Python dependencies to look like:
# @CODE
# python_single_target_pythonX_Y? ( dev-lang/python:X.Y[gdbm,ncurses(-)?] )
# @CODE

# @ECLASS-VARIABLE: PYTHON_DEPS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is an eclass-generated Python dependency string for all
# implementations listed in PYTHON_COMPAT.
#
# The dependency string is conditional on PYTHON_SINGLE_TARGET.
#
# Example use:
# @CODE
# RDEPEND="${PYTHON_DEPS}
#	dev-foo/mydep"
# BDEPEND="${PYTHON_DEPS}"
# @CODE
#
# Example value:
# @CODE
# dev-lang/python-exec:=
# python_single_target_python2_7? ( dev-lang/python:2.7[gdbm] )
# python_single_target_pypy? ( dev-python/pypy[gdbm] )
# @CODE

# @ECLASS-VARIABLE: PYTHON_SINGLE_USEDEP
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is an eclass-generated USE-dependency string which can be used to
# depend on another python-single-r1 package being built for the same
# Python implementations.
#
# If you need to depend on a multi-impl (python-r1) package, use
# python_gen_cond_dep with PYTHON_USEDEP placeholder instead.
#
# Example use:
# @CODE
# RDEPEND="dev-python/foo[${PYTHON_SINGLE_USEDEP}]"
# @CODE
#
# Example value:
# @CODE
# python_single_target_python3_4(-)?
# @CODE

# @ECLASS-VARIABLE: PYTHON_USEDEP
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is a placeholder variable supported by python_gen_cond_dep,
# in order to depend on python-r1 packages built for the same Python
# implementations.
#
# Example use:
# @CODE
# RDEPEND="$(python_gen_cond_dep '
#     dev-python/foo[${PYTHON_USEDEP}]
#   ')"
# @CODE
#
# Example value:
# @CODE
# python_targets_python3_4(-)
# @CODE

# @ECLASS-VARIABLE: PYTHON_MULTI_USEDEP
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is a backwards-compatibility placeholder.  Use PYTHON_USEDEP
# instead.

# @ECLASS-VARIABLE: PYTHON_REQUIRED_USE
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is an eclass-generated required-use expression which ensures
# that exactly one PYTHON_SINGLE_TARGET value has been enabled.
#
# This expression should be utilized in an ebuild by including it in
# REQUIRED_USE, optionally behind a use flag.
#
# Example use:
# @CODE
# REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
# @CODE
#
# Example value:
# @CODE
# ^^ ( python_single_target_python2_7 python_single_target_python3_3 )
# @CODE

_python_single_set_globals() {
	_python_set_impls

	local flags=( "${_PYTHON_SUPPORTED_IMPLS[@]/#/python_single_target_}" )

	if [[ ${#_PYTHON_SUPPORTED_IMPLS[@]} -eq 1 ]]; then
		# if only one implementation is supported, use IUSE defaults
		# to avoid requesting the user to enable it
		IUSE="+${flags[0]}"
	else
		IUSE="${flags[*]}"
	fi

	local requse="^^ ( ${flags[*]} )"
	local single_flags="${flags[@]/%/(-)?}"
	local single_usedep=${single_flags// /,}

	local deps= i PYTHON_PKG_DEP
	for i in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		_python_export "${i}" PYTHON_PKG_DEP
		# 1) well, python-exec would suffice as an RDEP
		# but no point in making this overcomplex, BDEP doesn't hurt anyone
		# 2) python-exec should be built with all targets forced anyway
		# but if new targets were added, we may need to force a rebuild
		deps+="python_single_target_${i}? (
			${PYTHON_PKG_DEP}
			>=dev-lang/python-exec-2:=[python_targets_${i}]
		) "
	done

	if [[ ${PYTHON_DEPS+1} ]]; then
		if [[ ${PYTHON_DEPS} != "${deps}" ]]; then
			eerror "PYTHON_DEPS have changed between inherits (PYTHON_REQ_USE?)!"
			eerror "Before: ${PYTHON_DEPS}"
			eerror "Now   : ${deps}"
			die "PYTHON_DEPS integrity check failed"
		fi

		# these two are formality -- they depend on PYTHON_COMPAT only
		if [[ ${PYTHON_REQUIRED_USE} != ${requse} ]]; then
			eerror "PYTHON_REQUIRED_USE have changed between inherits!"
			eerror "Before: ${PYTHON_REQUIRED_USE}"
			eerror "Now   : ${requse}"
			die "PYTHON_REQUIRED_USE integrity check failed"
		fi

		if [[ ${PYTHON_SINGLE_USEDEP} != "${single_usedep}" ]]; then
			eerror "PYTHON_SINGLE_USEDEP have changed between inherits!"
			eerror "Before: ${PYTHON_SINGLE_USEDEP}"
			eerror "Now   : ${single_usedep}"
			die "PYTHON_SINGLE_USEDEP integrity check failed"
		fi
	else
		PYTHON_DEPS=${deps}
		PYTHON_REQUIRED_USE=${requse}
		PYTHON_USEDEP='%PYTHON_USEDEP-NEEDS-TO-BE-USED-IN-PYTHON_GEN_COND_DEP%'
		PYTHON_SINGLE_USEDEP=${single_usedep}
		readonly PYTHON_DEPS PYTHON_REQUIRED_USE PYTHON_SINGLE_USEDEP \
			PYTHON_USEDEP
	fi
}
_python_single_set_globals
unset -f _python_single_set_globals

if [[ ! ${_PYTHON_SINGLE_R1} ]]; then

# @FUNCTION: _python_gen_usedep
# @USAGE: [<pattern>...]
# @INTERNAL
# @DESCRIPTION:
# Output a USE dependency string for Python implementations which
# are both in PYTHON_COMPAT and match any of the patterns passed
# as parameters to the function.
#
# The patterns can be either fnmatch-style patterns (matched via bash
# == operator against PYTHON_COMPAT values) or '-2' / '-3' to indicate
# appropriately all enabled Python 2/3 implementations (alike
# python_is_python3). Remember to escape or quote the fnmatch patterns
# to prevent accidental shell filename expansion.
#
# This is an internal function used to implement python_gen_cond_dep.
_python_gen_usedep() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl matches=()

	_python_verify_patterns "${@}"
	for impl in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		if _python_impl_matches "${impl}" "${@}"; then
			matches+=(
				"python_single_target_${impl}(-)?"
			)
		fi
	done

	[[ ${matches[@]} ]] || die "No supported implementations match python_gen_usedep patterns: ${@}"

	local out=${matches[@]}
	echo "${out// /,}"
}

# @FUNCTION: python_gen_useflags
# @USAGE: [<pattern>...]
# @DESCRIPTION:
# Output a list of USE flags for Python implementations which
# are both in PYTHON_COMPAT and match any of the patterns passed
# as parameters to the function.
#
# The patterns can be either fnmatch-style patterns (matched via bash
# == operator against PYTHON_COMPAT values) or '-2' / '-3' to indicate
# appropriately all enabled Python 2/3 implementations (alike
# python_is_python3). Remember to escape or quote the fnmatch patterns
# to prevent accidental shell filename expansion.
#
# Example:
# @CODE
# PYTHON_COMPAT=( python{2_7,3_4} )
# REQUIRED_USE="doc? ( ^^ ( $(python_gen_useflags 'python2*') ) )"
# @CODE
#
# It will cause the variable to look like:
# @CODE
# REQUIRED_USE="doc? ( ^^ ( python_single_target_python2_7 ) )"
# @CODE
python_gen_useflags() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl matches=()

	_python_verify_patterns "${@}"
	for impl in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		if _python_impl_matches "${impl}" "${@}"; then
			matches+=( "python_single_target_${impl}" )
		fi
	done

	echo "${matches[@]}"
}

# @FUNCTION: python_gen_cond_dep
# @USAGE: <dependency> [<pattern>...]
# @DESCRIPTION:
# Output a list of <dependency>-ies made conditional to USE flags
# of Python implementations which are both in PYTHON_COMPAT and match
# any of the patterns passed as the remaining parameters.
#
# The patterns can be either fnmatch-style patterns (matched via bash
# == operator against PYTHON_COMPAT values) or '-2' / '-3' to indicate
# appropriately all enabled Python 2/3 implementations (alike
# python_is_python3). Remember to escape or quote the fnmatch patterns
# to prevent accidental shell filename expansion.
#
# In order to enforce USE constraints on the packages, verbatim
# '${PYTHON_SINGLE_USEDEP}' and '${PYTHON_USEDEP}' (quoted!) may
# be placed in the dependency specification. It will get expanded within
# the function into a proper USE dependency string.
#
# Example:
# @CODE
# PYTHON_COMPAT=( python{2_7,3_{3,4}} pypy )
# RDEPEND="$(python_gen_cond_dep \
#   'dev-python/unittest2[${PYTHON_USEDEP}]' python2_7 pypy )"
# @CODE
#
# It will cause the variable to look like:
# @CODE
# RDEPEND="python_single_target_python2_7? (
#     dev-python/unittest2[python_targets_python2_7(-)?,...] )
#	python_single_target_pypy? (
#     dev-python/unittest2[python_targets_pypy(-)?,...] )"
# @CODE
python_gen_cond_dep() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl matches=()

	local dep=${1}
	shift

	_python_verify_patterns "${@}"
	for impl in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		if _python_impl_matches "${impl}" "${@}"; then
			# substitute ${PYTHON_SINGLE_USEDEP} if used
			# (since python_gen_usedep() will not return
			#  ${PYTHON_SINGLE_USEDEP}, the code is run at most once)
			if [[ ${dep} == *'${PYTHON_SINGLE_USEDEP}'* ]]; then
				local usedep=$(_python_gen_usedep "${@}")
				dep=${dep//\$\{PYTHON_SINGLE_USEDEP\}/${usedep}}
			fi
			local multi_usedep="python_targets_${impl}(-)"

			local subdep=${dep//\$\{PYTHON_MULTI_USEDEP\}/${multi_usedep}}
			matches+=( "python_single_target_${impl}? (
				${subdep//\$\{PYTHON_USEDEP\}/${multi_usedep}} )" )
		fi
	done

	echo "${matches[@]}"
}

# @FUNCTION: python_gen_impl_dep
# @USAGE: [<requested-use-flags> [<impl-pattern>...]]
# @DESCRIPTION:
# Output a dependency on Python implementations with the specified USE
# dependency string appended, or no USE dependency string if called
# without the argument (or with empty argument). If any implementation
# patterns are passed, the output dependencies will be generated only
# for the implementations matching them.
#
# The patterns can be either fnmatch-style patterns (matched via bash
# == operator against PYTHON_COMPAT values) or '-2' / '-3' to indicate
# appropriately all enabled Python 2/3 implementations (alike
# python_is_python3). Remember to escape or quote the fnmatch patterns
# to prevent accidental shell filename expansion.
#
# Use this function when you need to request different USE flags
# on the Python interpreter depending on package's USE flags. If you
# only need a single set of interpreter USE flags, just set
# PYTHON_REQ_USE and use ${PYTHON_DEPS} globally.
#
# Example:
# @CODE
# PYTHON_COMPAT=( python{2_7,3_{3,4}} pypy )
# RDEPEND="foo? ( $(python_gen_impl_dep 'xml(+)') )"
# @CODE
#
# It will cause the variable to look like:
# @CODE
# RDEPEND="foo? (
#   python_single_target_python2_7? (
#     dev-lang/python:2.7[xml(+)] )
#	python_single_target_pypy? (
#     dev-python/pypy[xml(+)] ) )"
# @CODE
python_gen_impl_dep() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl
	local matches=()

	local PYTHON_REQ_USE=${1}
	shift

	_python_verify_patterns "${@}"
	for impl in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		if _python_impl_matches "${impl}" "${@}"; then
			local PYTHON_PKG_DEP
			_python_export "${impl}" PYTHON_PKG_DEP
			matches+=( "python_single_target_${impl}? ( ${PYTHON_PKG_DEP} )" )
		fi
	done

	echo "${matches[@]}"
}

# @FUNCTION: python_setup
# @DESCRIPTION:
# Determine what the selected Python implementation is and set
# the Python build environment up for it.
python_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	unset EPYTHON

	# support developer override
	if [[ ${PYTHON_COMPAT_OVERRIDE} ]]; then
		local impls=( ${PYTHON_COMPAT_OVERRIDE} )
		[[ ${#impls[@]} -eq 1 ]] || die "PYTHON_COMPAT_OVERRIDE must name exactly one implementation for python-single-r1"

		ewarn "WARNING: PYTHON_COMPAT_OVERRIDE in effect. The following Python"
		ewarn "implementation will be used:"
		ewarn
		ewarn "	${PYTHON_COMPAT_OVERRIDE}"
		ewarn
		ewarn "Dependencies won't be satisfied, and PYTHON_SINGLE_TARGET flags will be ignored."

		_python_export "${impls[0]}" EPYTHON PYTHON
		_python_wrapper_setup
		einfo "Using ${EPYTHON} to build"
		return
	fi

	local impl
	for impl in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		if use "python_single_target_${impl}"; then
			if [[ ${EPYTHON} ]]; then
				eerror "Your PYTHON_SINGLE_TARGET setting lists more than a single Python"
				eerror "implementation. Please set it to just one value. If you need"
				eerror "to override the value for a single package, please use package.env"
				eerror "or an equivalent solution (man 5 portage)."
				echo
				die "More than one implementation in PYTHON_SINGLE_TARGET."
			fi

			_python_export "${impl}" EPYTHON PYTHON
			_python_wrapper_setup
			einfo "Using ${EPYTHON} to build"
		fi
	done

	if [[ ! ${EPYTHON} ]]; then
		eerror "No Python implementation selected for the build. Please set"
		eerror "the PYTHON_SINGLE_TARGET variable in your make.conf to one"
		eerror "of the following values:"
		eerror
		eerror "${_PYTHON_SUPPORTED_IMPLS[@]}"
		echo
		die "No supported Python implementation in PYTHON_SINGLE_TARGET."
	fi
}

# @FUNCTION: python-single-r1_pkg_setup
# @DESCRIPTION:
# Runs python_setup.
python-single-r1_pkg_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${MERGE_TYPE} != binary ]] && python_setup
}

_PYTHON_SINGLE_R1=1
fi
