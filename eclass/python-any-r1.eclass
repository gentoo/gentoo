# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: python-any-r1.eclass
# @MAINTAINER:
# Python team <python@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# Based on work of: Krzysztof Pawlik <nelchael@gentoo.org>
# @BLURB: An eclass for packages having build-time dependency on Python.
# @DESCRIPTION:
# A minimal eclass for packages which need any Python interpreter
# installed without a need for explicit choice and invariability.
# This usually involves packages requiring Python at build-time
# but having no other relevance to it.
#
# This eclass provides a minimal PYTHON_DEPS variable with a dependency
# string on any of the supported Python implementations. It also exports
# pkg_setup() which finds the best supported implementation and sets it
# as the active one.
#
# Optionally, you can define a python_check_deps() function. It will
# be called by the eclass with EPYTHON set to each matching Python
# implementation and it is expected to check whether the implementation
# fulfills the package requirements. You can use the locally exported
# PYTHON_USEDEP to check USE-dependencies of relevant packages. It
# should return a true value (0) if the Python implementation fulfills
# the requirements, a false value (non-zero) otherwise.
#
# Please note that python-any-r1 will always inherit python-utils-r1
# as well. Thus, all the functions defined there can be used in the
# packages using python-any-r1, and there is no need ever to inherit
# both.
#
# For more information, please see the wiki:
# https://wiki.gentoo.org/wiki/Project:Python/python-any-r1

case "${EAPI:-0}" in
	0|1|2|3|4|5|6)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

if [[ ! ${_PYTHON_ANY_R1} ]]; then

if [[ ${_PYTHON_R1} ]]; then
	die 'python-any-r1.eclass can not be used with python-r1.eclass.'
elif [[ ${_PYTHON_SINGLE_R1} ]]; then
	die 'python-any-r1.eclass can not be used with python-single-r1.eclass.'
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
# PYTHON_COMPAT=( python{2_5,2_6,2_7} )
# @CODE

# @ECLASS-VARIABLE: PYTHON_COMPAT_OVERRIDE
# @INTERNAL
# @DESCRIPTION:
# This variable can be used when working with ebuilds to override
# the in-ebuild PYTHON_COMPAT. It is a string naming the implementation
# which will be used to build the package. It needs to be specified
# in the calling environment, and not in ebuilds.
#
# It should be noted that in order to preserve metadata immutability,
# PYTHON_COMPAT_OVERRIDE does not affect dependencies. The value of
# EPYTHON and eselect-python preferences are ignored. Dependencies need
# to be satisfied manually.
#
# Example:
# @CODE
# PYTHON_COMPAT_OVERRIDE='pypy' emerge -1v dev-python/bar
# @CODE

# @ECLASS-VARIABLE: PYTHON_REQ_USE
# @DEFAULT_UNSET
# @DESCRIPTION:
# The list of USEflags required to be enabled on the Python
# implementations, formed as a USE-dependency string. It should be valid
# for all implementations in PYTHON_COMPAT, so it may be necessary to
# use USE defaults.
#
# Example:
# @CODE
# PYTHON_REQ_USE="gdbm,ncurses(-)?"
# @CODE
#
# It will cause the Python dependencies to look like:
# @CODE
# || ( dev-lang/python:X.Y[gdbm,ncurses(-)?] ... )
# @CODE

# @ECLASS-VARIABLE: PYTHON_DEPS
# @DESCRIPTION:
# This is an eclass-generated Python dependency string for all
# implementations listed in PYTHON_COMPAT.
#
# Any of the supported interpreters will satisfy the dependency.
#
# Example use:
# @CODE
# DEPEND="${RDEPEND}
#	${PYTHON_DEPS}"
# @CODE
#
# Example value:
# @CODE
# || ( dev-lang/python:2.7[gdbm]
# 	dev-lang/python:2.6[gdbm] )
# @CODE

# @ECLASS-VARIABLE: PYTHON_USEDEP
# @DESCRIPTION:
# An eclass-generated USE-dependency string for the currently tested
# implementation. It is set locally for python_check_deps() call.
#
# The generate USE-flag list is compatible with packages using python-r1,
# python-single-r1 and python-distutils-ng eclasses. It must not be used
# on packages using python.eclass.
#
# Example use:
# @CODE
# python_check_deps() {
#	has_version "dev-python/foo[${PYTHON_USEDEP}]"
# }
# @CODE
#
# Example value:
# @CODE
# python_targets_python2_7(-)?,python_single_target_python2_7(+)?
# @CODE

_python_any_set_globals() {
	local usestr deps i PYTHON_PKG_DEP
	[[ ${PYTHON_REQ_USE} ]] && usestr="[${PYTHON_REQ_USE}]"

	_python_set_impls

	for i in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		python_export "${i}" PYTHON_PKG_DEP

		# note: need to strip '=' slot operator for || deps
		deps="${PYTHON_PKG_DEP%=} ${deps}"
	done
	deps="|| ( ${deps})"

	if [[ ${PYTHON_DEPS+1} ]]; then
		if [[ ${PYTHON_DEPS} != "${deps}" ]]; then
			eerror "PYTHON_DEPS have changed between inherits (PYTHON_REQ_USE?)!"
			eerror "Before: ${PYTHON_DEPS}"
			eerror "Now   : ${deps}"
			die "PYTHON_DEPS integrity check failed"
		fi
	else
		PYTHON_DEPS=${deps}
		readonly PYTHON_DEPS
	fi
}
_python_any_set_globals
unset -f _python_any_set_globals

if [[ ! ${_PYTHON_ANY_R1} ]]; then

# @FUNCTION: python_gen_any_dep
# @USAGE: <dependency-block>
# @DESCRIPTION:
# Generate an any-of dependency that enforces a version match between
# the Python interpreter and Python packages. <dependency-block> needs
# to list one or more dependencies with verbatim '${PYTHON_USEDEP}'
# references (quoted!) that will get expanded inside the function.
#
# This should be used along with an appropriate python_check_deps()
# that checks which of the any-of blocks were matched.
#
# Example use:
# @CODE
# DEPEND="$(python_gen_any_dep '
#	dev-python/foo[${PYTHON_USEDEP}]
#	|| ( dev-python/bar[${PYTHON_USEDEP}]
#		dev-python/baz[${PYTHON_USEDEP}] )')"
#
# python_check_deps() {
#	has_version "dev-python/foo[${PYTHON_USEDEP}]" \
#		&& { has_version "dev-python/bar[${PYTHON_USEDEP}]" \
#			|| has_version "dev-python/baz[${PYTHON_USEDEP}]"; }
# }
# @CODE
#
# Example value:
# @CODE
# || (
#	(
#		dev-lang/python:2.7
#		dev-python/foo[python_targets_python2_7(-)?,python_single_target_python2_7(+)?]
#		|| ( dev-python/bar[python_targets_python2_7(-)?,python_single_target_python2_7(+)?]
#			dev-python/baz[python_targets_python2_7(-)?,python_single_target_python2_7(+)?] )
#	)
#	(
#		dev-lang/python:3.3
#		dev-python/foo[python_targets_python3_3(-)?,python_single_target_python3_3(+)?]
#		|| ( dev-python/bar[python_targets_python3_3(-)?,python_single_target_python3_3(+)?]
#			dev-python/baz[python_targets_python3_3(-)?,python_single_target_python3_3(+)?] )
#	)
# )
# @CODE
python_gen_any_dep() {
	debug-print-function ${FUNCNAME} "${@}"

	local depstr=${1}
	[[ ${depstr} ]] || die "No dependency string provided"

	local PYTHON_PKG_DEP out=
	for i in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		local PYTHON_USEDEP="python_targets_${i}(-),python_single_target_${i}(+)"
		python_export "${i}" PYTHON_PKG_DEP

		local i_depstr=${depstr//\$\{PYTHON_USEDEP\}/${PYTHON_USEDEP}}
		# note: need to strip '=' slot operator for || deps
		out="( ${PYTHON_PKG_DEP%=} ${i_depstr} ) ${out}"
	done
	echo "|| ( ${out})"
}

# @FUNCTION: _python_EPYTHON_supported
# @USAGE: <epython>
# @INTERNAL
# @DESCRIPTION:
# Check whether the specified implementation is supported by package
# (specified in PYTHON_COMPAT). Calls python_check_deps() if declared.
_python_EPYTHON_supported() {
	debug-print-function ${FUNCNAME} "${@}"

	local EPYTHON=${1}
	local i=${EPYTHON/./_}

	case "${i}" in
		python*|jython*|pypy*)
			;;
		*)
			ewarn "Invalid EPYTHON: ${EPYTHON}"
			return 1
			;;
	esac

	if has "${i}" "${_PYTHON_SUPPORTED_IMPLS[@]}"; then
		if python_is_installed "${i}"; then
			if declare -f python_check_deps >/dev/null; then
				local PYTHON_USEDEP="python_targets_${i}(-),python_single_target_${i}(+)"
				python_check_deps
				return ${?}
			fi

			return 0
		fi
	elif ! has "${i}" "${_PYTHON_ALL_IMPLS[@]}"; then
		ewarn "Invalid EPYTHON: ${EPYTHON}"
	fi
	return 1
}

# @FUNCTION: python_setup
# @DESCRIPTION:
# Determine what the best installed (and supported) Python
# implementation is, and set the Python build environment up for it.
#
# This function will call python_check_deps() if defined.
python_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	# support developer override
	if [[ ${PYTHON_COMPAT_OVERRIDE} ]]; then
		local impls=( ${PYTHON_COMPAT_OVERRIDE} )
		[[ ${#impls[@]} -eq 1 ]] || die "PYTHON_COMPAT_OVERRIDE must name exactly one implementation for python-any-r1"

		ewarn "WARNING: PYTHON_COMPAT_OVERRIDE in effect. The following Python"
		ewarn "implementation will be used:"
		ewarn
		ewarn "	${PYTHON_COMPAT_OVERRIDE}"
		ewarn
		ewarn "Dependencies won't be satisfied, and EPYTHON/eselect-python will be ignored."

		python_export "${impls[0]}" EPYTHON PYTHON
		python_wrapper_setup
		return
	fi

	# first, try ${EPYTHON}... maybe it's good enough for us.
	if [[ ${EPYTHON} ]]; then
		if _python_EPYTHON_supported "${EPYTHON}"; then
			python_export EPYTHON PYTHON
			python_wrapper_setup
			return
		fi
	fi

	# then, try eselect-python
	local variant i
	for variant in '' '--python2' '--python3'; do
		i=$(eselect python --show ${variant} 2>/dev/null)

		if [[ ! ${i} ]]; then
			# no eselect-python?
			break
		elif _python_EPYTHON_supported "${i}"; then
			python_export "${i}" EPYTHON PYTHON
			python_wrapper_setup
			return
		fi
	done

	# fallback to best installed impl.
	# (reverse iteration over _PYTHON_SUPPORTED_IMPLS)
	for (( i = ${#_PYTHON_SUPPORTED_IMPLS[@]} - 1; i >= 0; i-- )); do
		python_export "${_PYTHON_SUPPORTED_IMPLS[i]}" EPYTHON PYTHON
		if _python_EPYTHON_supported "${EPYTHON}"; then
			python_wrapper_setup
			return
		fi
	done

	eerror "No Python implementation found for the build. This is usually"
	eerror "a bug in the ebuild. Please report it to bugs.gentoo.org"
	eerror "along with the build log."
	echo
	die "No supported Python implementation installed."
}

# @FUNCTION: python-any-r1_pkg_setup
# @DESCRIPTION:
# Runs python_setup during from-source installs.
#
# In a binary package installs is a no-op. If you need Python in pkg_*
# phases of a binary package, call python_setup directly.
python-any-r1_pkg_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${MERGE_TYPE} != binary ]] && python_setup
}

_PYTHON_ANY_R1=1
fi
