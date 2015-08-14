# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: python-r1.eclass
# @MAINTAINER:
# Python team <python@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# Based on work of: Krzysztof Pawlik <nelchael@gentoo.org>
# @BLURB: A common, simple eclass for Python packages.
# @DESCRIPTION:
# A common eclass providing helper functions to build and install
# packages supporting being installed for multiple Python
# implementations.
#
# This eclass sets correct IUSE. Modification of REQUIRED_USE has to
# be done by the author of the ebuild (but PYTHON_REQUIRED_USE is
# provided for convenience, see below). python-r1 exports PYTHON_DEPS
# and PYTHON_USEDEP so you can create correct dependencies for your
# package easily. It also provides methods to easily run a command for
# each enabled Python implementation and duplicate the sources for them.
#
# Please note that python-r1 will always inherit python-utils-r1 as
# well. Thus, all the functions defined there can be used
# in the packages using python-r1, and there is no need ever to inherit
# both.
#
# For more information, please see the wiki:
# https://wiki.gentoo.org/wiki/Project:Python/python-r1

case "${EAPI:-0}" in
	0|1|2|3)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	4)
		# EAPI=4 is only allowed on legacy packages
		if [[ ${CATEGORY}/${P} == dev-python/pyelftools-0.2[123] ]]; then
			:
		elif [[ ${CATEGORY}/${P} == sys-apps/file-5.22 ]]; then
			:
		elif [[ ${CATEGORY}/${P} == sys-apps/i2c-tools-3.1.1 ]]; then
			:
		elif [[ ${CATEGORY}/${P} == sys-libs/cracklib-2.9.[12] ]]; then
			:
		else
			die "Unsupported EAPI=${EAPI:-4} (too old, allowed only on restricted set of packages) for ${ECLASS}"
		fi
		;;
	5)
		# EAPI=5 is required for sane USE_EXPAND dependencies
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

if [[ ! ${_PYTHON_R1} ]]; then

if [[ ${_PYTHON_SINGLE_R1} ]]; then
	die 'python-r1.eclass can not be used with python-single-r1.eclass.'
elif [[ ${_PYTHON_ANY_R1} ]]; then
	die 'python-r1.eclass can not be used with python-any-r1.eclass.'
fi

inherit multibuild python-utils-r1

# @ECLASS-VARIABLE: PYTHON_COMPAT
# @REQUIRED
# @DESCRIPTION:
# This variable contains a list of Python implementations the package
# supports. It must be set before the `inherit' call. It has to be
# an array.
#
# Example:
# @CODE
# PYTHON_COMPAT=( python2_5 python2_6 python2_7 )
# @CODE
#
# Please note that you can also use bash brace expansion if you like:
# @CODE
# PYTHON_COMPAT=( python{2_5,2_6,2_7} )
# @CODE
if ! declare -p PYTHON_COMPAT &>/dev/null; then
	die 'PYTHON_COMPAT not declared.'
fi

# @ECLASS-VARIABLE: PYTHON_COMPAT_OVERRIDE
# @INTERNAL
# @DESCRIPTION:
# This variable can be used when working with ebuilds to override
# the in-ebuild PYTHON_COMPAT. It is a string listing all
# the implementations which package will be built for. It need be
# specified in the calling environment, and not in ebuilds.
#
# It should be noted that in order to preserve metadata immutability,
# PYTHON_COMPAT_OVERRIDE does not affect IUSE nor dependencies.
# The state of PYTHON_TARGETS is ignored, and all the implementations
# in PYTHON_COMPAT_OVERRIDE are built. Dependencies need to be satisfied
# manually.
#
# Example:
# @CODE
# PYTHON_COMPAT_OVERRIDE='pypy python3_3' emerge -1v dev-python/foo
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
# python_targets_pythonX_Y? ( dev-lang/python:X.Y[gdbm,ncurses(-)?] )
# @CODE

# @ECLASS-VARIABLE: PYTHON_DEPS
# @DESCRIPTION:
# This is an eclass-generated Python dependency string for all
# implementations listed in PYTHON_COMPAT.
#
# Example use:
# @CODE
# RDEPEND="${PYTHON_DEPS}
#	dev-foo/mydep"
# DEPEND="${RDEPEND}"
# @CODE
#
# Example value:
# @CODE
# dev-lang/python-exec:=
# python_targets_python2_6? ( dev-lang/python:2.6[gdbm] )
# python_targets_python2_7? ( dev-lang/python:2.7[gdbm] )
# @CODE

# @ECLASS-VARIABLE: PYTHON_USEDEP
# @DESCRIPTION:
# This is an eclass-generated USE-dependency string which can be used to
# depend on another Python package being built for the same Python
# implementations.
#
# The generate USE-flag list is compatible with packages using python-r1
# and python-distutils-ng eclasses. It must not be used on packages
# using python.eclass.
#
# Example use:
# @CODE
# RDEPEND="dev-python/foo[${PYTHON_USEDEP}]"
# @CODE
#
# Example value:
# @CODE
# python_targets_python2_6(-)?,python_targets_python2_7(-)?
# @CODE

# @ECLASS-VARIABLE: PYTHON_REQUIRED_USE
# @DESCRIPTION:
# This is an eclass-generated required-use expression which ensures at
# least one Python implementation has been enabled.
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
# || ( python_targets_python2_6 python_targets_python2_7 )
# @CODE

_python_set_globals() {
	local impls=()

	PYTHON_DEPS=
	local i PYTHON_PKG_DEP
	for i in "${PYTHON_COMPAT[@]}"; do
		_python_impl_supported "${i}" || continue

		python_export "${i}" PYTHON_PKG_DEP
		PYTHON_DEPS+="python_targets_${i}? ( ${PYTHON_PKG_DEP} ) "

		impls+=( "${i}" )
	done

	if [[ ${#impls[@]} -eq 0 ]]; then
		die "No supported implementation in PYTHON_COMPAT."
	fi

	local flags=( "${impls[@]/#/python_targets_}" )
	local optflags=${flags[@]/%/(-)?}

	# A nice QA trick here. Since a python-single-r1 package has to have
	# at least one PYTHON_SINGLE_TARGET enabled (REQUIRED_USE),
	# the following check will always fail on those packages. Therefore,
	# it should prevent developers from mistakenly depending on packages
	# not supporting multiple Python implementations.

	local flags_st=( "${impls[@]/#/-python_single_target_}" )
	optflags+=,${flags_st[@]/%/(-)}

	IUSE=${flags[*]}
	PYTHON_REQUIRED_USE="|| ( ${flags[*]} )"
	PYTHON_USEDEP=${optflags// /,}

	# 1) well, python-exec would suffice as an RDEP
	# but no point in making this overcomplex, BDEP doesn't hurt anyone
	# 2) python-exec should be built with all targets forced anyway
	# but if new targets were added, we may need to force a rebuild
	# 3) use whichever python-exec slot installed in EAPI 5. For EAPI 4,
	# just fix :2 since := deps are not supported.
	if [[ ${_PYTHON_WANT_PYTHON_EXEC2} == 0 ]]; then
		die "python-exec:0 is no longer supported, please fix your ebuild to work with python-exec:2"
	elif [[ ${EAPI} != 4 ]]; then
		PYTHON_DEPS+=">=dev-lang/python-exec-2:=[${PYTHON_USEDEP}]"
	else
		PYTHON_DEPS+="dev-lang/python-exec:2[${PYTHON_USEDEP}]"
	fi
}
_python_set_globals

# @FUNCTION: _python_validate_useflags
# @INTERNAL
# @DESCRIPTION:
# Enforce the proper setting of PYTHON_TARGETS.
_python_validate_useflags() {
	debug-print-function ${FUNCNAME} "${@}"

	local i

	for i in "${PYTHON_COMPAT[@]}"; do
		_python_impl_supported "${i}" || continue

		use "python_targets_${i}" && return 0
	done

	eerror "No Python implementation selected for the build. Please add one"
	eerror "of the following values to your PYTHON_TARGETS (in make.conf):"
	eerror
	eerror "${PYTHON_COMPAT[@]}"
	echo
	die "No supported Python implementation in PYTHON_TARGETS."
}

# @FUNCTION: python_gen_usedep
# @USAGE: <pattern> [...]
# @DESCRIPTION:
# Output a USE dependency string for Python implementations which
# are both in PYTHON_COMPAT and match any of the patterns passed
# as parameters to the function.
#
# Remember to escape or quote the patterns to prevent shell filename
# expansion.
#
# When all implementations are requested, please use ${PYTHON_USEDEP}
# instead. Please also remember to set an appropriate REQUIRED_USE
# to avoid ineffective USE flags.
#
# Example:
# @CODE
# PYTHON_COMPAT=( python{2_7,3_4} )
# DEPEND="doc? ( dev-python/epydoc[$(python_gen_usedep 'python2*')] )"
# @CODE
#
# It will cause the dependency to look like:
# @CODE
# DEPEND="doc? ( dev-python/epydoc[python_targets_python2_7?] )"
# @CODE
python_gen_usedep() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl pattern
	local matches=()

	for impl in "${PYTHON_COMPAT[@]}"; do
		_python_impl_supported "${impl}" || continue

		for pattern; do
			if [[ ${impl} == ${pattern} ]]; then
				matches+=(
					"python_targets_${impl}(-)?"
					"-python_single_target_${impl}(-)"
				)
				break
			fi
		done
	done

	[[ ${matches[@]} ]] || die "No supported implementations match python_gen_usedep patterns: ${@}"

	local out=${matches[@]}
	echo "${out// /,}"
}

# @FUNCTION: python_gen_useflags
# @USAGE: <pattern> [...]
# @DESCRIPTION:
# Output a list of USE flags for Python implementations which
# are both in PYTHON_COMPAT and match any of the patterns passed
# as parameters to the function.
#
# Example:
# @CODE
# PYTHON_COMPAT=( python{2_7,3_4} )
# REQUIRED_USE="doc? ( || ( $(python_gen_useflags python2*) ) )"
# @CODE
#
# It will cause the variable to look like:
# @CODE
# REQUIRED_USE="doc? ( || ( python_targets_python2_7 ) )"
# @CODE
python_gen_useflags() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl pattern
	local matches=()

	for impl in "${PYTHON_COMPAT[@]}"; do
		_python_impl_supported "${impl}" || continue

		for pattern; do
			if [[ ${impl} == ${pattern} ]]; then
				matches+=( "python_targets_${impl}" )
				break
			fi
		done
	done

	echo "${matches[@]}"
}

# @FUNCTION: python_gen_cond_dep
# @USAGE: <dependency> <pattern> [...]
# @DESCRIPTION:
# Output a list of <dependency>-ies made conditional to USE flags
# of Python implementations which are both in PYTHON_COMPAT and match
# any of the patterns passed as the remaining parameters.
#
# In order to enforce USE constraints on the packages, verbatim
# '${PYTHON_USEDEP}' (quoted!) may be placed in the dependency
# specification. It will get expanded within the function into a proper
# USE dependency string.
#
# Example:
# @CODE
# PYTHON_COMPAT=( python{2_5,2_6,2_7} )
# RDEPEND="$(python_gen_cond_dep \
#   'dev-python/unittest2[${PYTHON_USEDEP}]' python{2_5,2_6})"
# @CODE
#
# It will cause the variable to look like:
# @CODE
# RDEPEND="python_targets_python2_5? (
#     dev-python/unittest2[python_targets_python2_5?] )
#	python_targets_python2_6? (
#     dev-python/unittest2[python_targets_python2_6?] )"
# @CODE
python_gen_cond_dep() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl pattern
	local matches=()

	local dep=${1}
	shift

	for impl in "${PYTHON_COMPAT[@]}"; do
		_python_impl_supported "${impl}" || continue

		for pattern; do
			if [[ ${impl} == ${pattern} ]]; then
				# substitute ${PYTHON_USEDEP} if used
				# (since python_gen_usedep() will not return ${PYTHON_USEDEP}
				#  the code is run at most once)
				if [[ ${dep} == *'${PYTHON_USEDEP}'* ]]; then
					local PYTHON_USEDEP=$(python_gen_usedep "${@}")
					dep=${dep//\$\{PYTHON_USEDEP\}/${PYTHON_USEDEP}}
				fi

				matches+=( "python_targets_${impl}? ( ${dep} )" )
				break
			fi
		done
	done

	echo "${matches[@]}"
}

# @ECLASS-VARIABLE: BUILD_DIR
# @DESCRIPTION:
# The current build directory. In global scope, it is supposed to
# contain an initial build directory; if unset, it defaults to ${S}.
#
# In functions run by python_foreach_impl(), the BUILD_DIR is locally
# set to an implementation-specific build directory. That path is
# created through appending a hyphen and the implementation name
# to the final component of the initial BUILD_DIR.
#
# Example value:
# @CODE
# ${WORKDIR}/foo-1.3-python2_6
# @CODE

# @FUNCTION: python_copy_sources
# @DESCRIPTION:
# Create a single copy of the package sources for each enabled Python
# implementation.
#
# The sources are always copied from initial BUILD_DIR (or S if unset)
# to implementation-specific build directory matching BUILD_DIR used by
# python_foreach_abi().
python_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_python_obtain_impls

	multibuild_copy_sources
}

# @FUNCTION: _python_obtain_impls
# @INTERNAL
# @DESCRIPTION:
# Set up the enabled implementation list.
_python_obtain_impls() {
	if [[ ${PYTHON_COMPAT_OVERRIDE} ]]; then
		if [[ ! ${_PYTHON_COMPAT_OVERRIDE_WARNED} ]]; then
			ewarn "WARNING: PYTHON_COMPAT_OVERRIDE in effect. The following Python"
			ewarn "implementations will be enabled:"
			ewarn
			ewarn "	${PYTHON_COMPAT_OVERRIDE}"
			ewarn
			ewarn "Dependencies won't be satisfied, and PYTHON_TARGETS will be ignored."
			_PYTHON_COMPAT_OVERRIDE_WARNED=1
		fi

		MULTIBUILD_VARIANTS=( ${PYTHON_COMPAT_OVERRIDE} )
		return
	fi

	_python_validate_useflags

	MULTIBUILD_VARIANTS=()

	for impl in "${_PYTHON_ALL_IMPLS[@]}"; do
		if has "${impl}" "${PYTHON_COMPAT[@]}" \
			&& use "python_targets_${impl}"
		then
			MULTIBUILD_VARIANTS+=( "${impl}" )
		fi
	done
}

# @FUNCTION: _python_multibuild_wrapper
# @USAGE: <command> [<args>...]
# @INTERNAL
# @DESCRIPTION:
# Initialize the environment for Python implementation selected
# for multibuild.
_python_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	local -x EPYTHON PYTHON
	local -x PATH=${PATH} PKG_CONFIG_PATH=${PKG_CONFIG_PATH}
	python_export "${MULTIBUILD_VARIANT}" EPYTHON PYTHON
	python_wrapper_setup

	"${@}"
}

# @FUNCTION: python_foreach_impl
# @USAGE: <command> [<args>...]
# @DESCRIPTION:
# Run the given command for each of the enabled Python implementations.
# If additional parameters are passed, they will be passed through
# to the command.
#
# The function will return 0 status if all invocations succeed.
# Otherwise, the return code from first failing invocation will
# be returned.
#
# For each command being run, EPYTHON, PYTHON and BUILD_DIR are set
# locally, and the former two are exported to the command environment.
python_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_python_obtain_impls

	multibuild_foreach_variant _python_multibuild_wrapper "${@}"
}

# @FUNCTION: python_parallel_foreach_impl
# @USAGE: <command> [<args>...]
# @DESCRIPTION:
# Run the given command for each of the enabled Python implementations.
# If additional parameters are passed, they will be passed through
# to the command.
#
# The function will return 0 status if all invocations succeed.
# Otherwise, the return code from first failing invocation will
# be returned.
#
# For each command being run, EPYTHON, PYTHON and BUILD_DIR are set
# locally, and the former two are exported to the command environment.
#
# This command used to be the parallel variant of python_foreach_impl.
# However, the parallel run support has been removed to simplify
# the eclasses and make them more predictable and therefore it is now
# only a deprecated alias to python_foreach_impl.
python_parallel_foreach_impl() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ ! ${_PYTHON_PARALLEL_WARNED} ]]; then
		eqawarn "python_parallel_foreach_impl() is no longer meaningful. All runs"
		eqawarn "are non-parallel now. Please replace the call with python_foreach_impl."

		_PYTHON_PARALLEL_WARNED=1
	fi

	local MULTIBUILD_VARIANTS
	_python_obtain_impls
	multibuild_foreach_variant _python_multibuild_wrapper "${@}"
}

# @FUNCTION: python_setup
# @USAGE: [<impl-pattern>...]
# @DESCRIPTION:
# Find the best (most preferred) Python implementation that is enabled
# and matches at least one of the patterns passed (or '*' if no patterns
# passed). Set the Python build environment up for that implementation.
#
# This function needs to be used when Python is being called outside
# of python_foreach_impl calls (e.g. for shared processes like doc
# building). python_foreach_impl sets up the build environment itself.
#
# If the specific commands support only a subset of Python
# implementations, patterns need to be passed to restrict the allowed
# implementations.
#
# Example:
# @CODE
# DEPEND="doc? ( dev-python/epydoc[$(python_gen_usedep 'python2*')] )"
#
# src_compile() {
#   #...
#   if use doc; then
#     python_setup 'python2*'
#     make doc
#   fi
# }
# @CODE
python_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	local best_impl patterns=( "${@-*}" )
	_python_try_impl() {
		local pattern
		for pattern in "${patterns[@]}"; do
			if [[ ${EPYTHON} == ${pattern} ]]; then
				best_impl=${EPYTHON}
			fi
		done
	}
	python_foreach_impl _python_try_impl

	if [[ ! ${best_impl} ]]; then
		eerror "${FUNCNAME}: none of the enabled implementation matched the patterns."
		eerror "  patterns: ${@-'(*)'}"
		eerror "Likely a REQUIRED_USE constraint (possibly USE-conditional) is missing."
		eerror "  suggested: || ( \$(python_gen_useflags ${@}) )"
		eerror "(remember to quote all the patterns with '')"
		die "${FUNCNAME}: no enabled implementation satisfy requirements"
	fi

	python_export "${best_impl}" EPYTHON PYTHON
	python_wrapper_setup
}

# @FUNCTION: python_export_best
# @USAGE: [<variable>...]
# @DESCRIPTION:
# Find the best (most preferred) Python implementation enabled
# and export given variables for it. If no variables are provided,
# EPYTHON & PYTHON will be exported.
python_export_best() {
	debug-print-function ${FUNCNAME} "${@}"

	eqawarn "python_export_best() is deprecated. Please use python_setup instead,"
	eqawarn "combined with python_export if necessary."

	[[ ${#} -gt 0 ]] || set -- EPYTHON PYTHON

	local best MULTIBUILD_VARIANTS
	_python_obtain_impls

	_python_set_best() {
		best=${MULTIBUILD_VARIANT}
	}
	multibuild_for_best_variant _python_set_best

	debug-print "${FUNCNAME}: Best implementation is: ${best}"
	python_export "${best}" "${@}"
	python_wrapper_setup
}

# @FUNCTION: python_replicate_script
# @USAGE: <path>...
# @DESCRIPTION:
# Copy the given script to variants for all enabled Python
# implementations, then replace it with a symlink to the wrapper.
#
# All specified files must start with a 'python' shebang. A file not
# having a matching shebang will be refused.
python_replicate_script() {
	debug-print-function ${FUNCNAME} "${@}"

	_python_replicate_script() {
		local _PYTHON_FIX_SHEBANG_QUIET=1

		local PYTHON_SCRIPTDIR
		python_export PYTHON_SCRIPTDIR

		(
			exeinto "${PYTHON_SCRIPTDIR#${EPREFIX}}"
			doexe "${files[@]}"
		)

		python_fix_shebang -q \
			"${files[@]/*\//${D%/}/${PYTHON_SCRIPTDIR}/}"
	}

	local files=( "${@}" )
	python_foreach_impl _python_replicate_script

	# install the wrappers
	local f
	for f; do
		_python_ln_rel "${ED%/}/usr/lib/python-exec/python-exec2" "${f}" || die
	done
}

_PYTHON_R1=1
fi
