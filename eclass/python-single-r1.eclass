# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: python-single-r1.eclass
# @MAINTAINER:
# Python team <python@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# Based on work of: Krzysztof Pawlik <nelchael@gentoo.org>
# @BLURB: An eclass for Python packages not installed for multiple implementations.
# @DESCRIPTION:
# An extension of the python-r1 eclass suite for packages which
# don't support being installed for multiple Python implementations.
# This mostly includes tools embedding Python.
#
# This eclass extends the IUSE and REQUIRED_USE set by python-r1
# to request the PYTHON_SINGLE_TARGET when the inheriting ebuild
# can be supported by more than one Python implementation. It also
# replaces PYTHON_USEDEP and PYTHON_DEPS with a more suitable form.
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
# For more information, please see the wiki:
# https://wiki.gentoo.org/wiki/Project:Python/python-single-r1

case "${EAPI:-0}" in
	0|1|2|3)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	4)
		# EAPI=4 is only allowed on legacy packages
		if [[ ${CATEGORY}/${P} == app-arch/threadzip-1.2 ]]; then
			:
		elif [[ ${CATEGORY}/${P} == media-libs/lv2-1.8.0 ]]; then
			:
		elif [[ ${CATEGORY}/${P} == media-libs/lv2-1.10.0 ]]; then
			:
		elif [[ ${CATEGORY}/${P} == sys-apps/paludis-1* ]]; then
			:
		elif [[ ${CATEGORY}/${P} == sys-apps/paludis-2.[02].0 ]]; then
			:
		elif [[ ${CATEGORY}/${P} == sys-apps/util-linux-2.2[456]* ]]; then
			:
		elif [[ ${CATEGORY}/${P} == */gdb-7.[78]* ]]; then
			:
		else
			die "Unsupported EAPI=${EAPI:-4} (too old, allowed only on restricted set of packages) for ${ECLASS}"
		fi
		;;
	5|6)
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

if [[ ! ${_PYTHON_SINGLE_R1} ]]; then

# @ECLASS-VARIABLE: PYTHON_COMPAT
# @REQUIRED
# @DESCRIPTION:
# This variable contains a list of Python implementations the package
# supports. It must be set before the `inherit' call. It has to be
# an array.
#
# Example:
# @CODE
# PYTHON_COMPAT=( python2_7 python3_3 python3_4} )
# @CODE
#
# Please note that you can also use bash brace expansion if you like:
# @CODE
# PYTHON_COMPAT=( python2_7 python3_{3,4} )
# @CODE
if ! declare -p PYTHON_COMPAT &>/dev/null; then
	die 'PYTHON_COMPAT not declared.'
fi
if [[ $(declare -p PYTHON_COMPAT) != "declare -a"* ]]; then
	die 'PYTHON_COMPAT must be an array.'
fi

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
# DEPEND="${RDEPEND}"
# @CODE
#
# Example value:
# @CODE
# dev-lang/python-exec:=
# python_single_target_python2_7? ( dev-lang/python:2.7[gdbm] )
# python_single_target_pypy? ( virtual/pypy[gdbm] )
# @CODE

# @ECLASS-VARIABLE: PYTHON_USEDEP
# @DESCRIPTION:
# This is an eclass-generated USE-dependency string which can be used to
# depend on another Python package being built for the same Python
# implementations.
#
# The generate USE-flag list is compatible with packages using python-r1,
# python-single-r1 and python-distutils-ng eclasses. It must not be used
# on packages using python.eclass.
#
# Example use:
# @CODE
# RDEPEND="dev-python/foo[${PYTHON_USEDEP}]"
# @CODE
#
# Example value:
# @CODE
# python_targets_python2_7(-)?,python_single_target_python3_4(+)?
# @CODE

# @ECLASS-VARIABLE: PYTHON_REQUIRED_USE
# @DESCRIPTION:
# This is an eclass-generated required-use expression which ensures the following
# when more than one python implementation is possible:
# 1. Exactly one PYTHON_SINGLE_TARGET value has been enabled.
# 2. The selected PYTHON_SINGLE_TARGET value is enabled in PYTHON_TARGETS.
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
# python_single_target_python2_7? ( python_targets_python2_7 )
# python_single_target_python3_3? ( python_targets_python3_3 )
# ^^ ( python_single_target_python2_7 python_single_target_python3_3 )
# @CODE

_python_single_set_globals() {
	local impls=()
	local unimpls=()

	PYTHON_DEPS=
	local i PYTHON_PKG_DEP
	for i in "${_PYTHON_ALL_IMPLS[@]}"; do
		has "${i}" "${PYTHON_COMPAT[@]}" \
			&& impls+=( "${i}" ) \
			|| unimpls+=( "${i}" )
	done

	if [[ ${#impls[@]} -eq 0 ]]; then
		die "No supported implementation in PYTHON_COMPAT."
	fi

	local flags_mt=( "${impls[@]/#/python_targets_}" )
	local flags=( "${impls[@]/#/python_single_target_}" )
	local unflags=( "${unimpls[@]/#/-python_single_target_}" )

	local optflags=${flags_mt[@]/%/(-)?},${unflags[@]/%/(-)}

	IUSE="${flags_mt[*]}"

	if [[ ${#impls[@]} -eq 1 ]]; then
		# There is only one supported implementation; set IUSE and other
		# variables without PYTHON_SINGLE_TARGET.
		PYTHON_REQUIRED_USE="${flags_mt[*]}"
		python_export "${impls[0]}" PYTHON_PKG_DEP
		PYTHON_DEPS="${PYTHON_PKG_DEP} "
		# Force on the python_single_target_* flag for this impl, so
		# that any dependencies that inherit python-single-r1 and
		# happen to have multiple implementations will still need
		# to bound by the implementation used by this package.
		optflags+=,${flags[0]/%/(+)}
	else
		# Multiple supported implementations; honor PYTHON_SINGLE_TARGET.
		IUSE+=" ${flags[*]}"
		PYTHON_REQUIRED_USE="^^ ( ${flags[*]} )"
		# Ensure deps honor the same python_single_target_* flag as is set
		# on this package.
		optflags+=,${flags[@]/%/(+)?}

		for i in "${impls[@]}"; do
			# The chosen targets need to be in PYTHON_TARGETS as well.
			# This is in order to enforce correct dependencies on packages
			# supporting multiple implementations.
			PYTHON_REQUIRED_USE+=" python_single_target_${i}? ( python_targets_${i} )"

			python_export "${i}" PYTHON_PKG_DEP
			PYTHON_DEPS+="python_single_target_${i}? ( ${PYTHON_PKG_DEP} ) "
		done
	fi
	declare -g -r PYTHON_USEDEP=${optflags// /,}

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
	readonly PYTHON_DEPS PYTHON_REQUIRED_USE
}
_python_single_set_globals
unset -f _python_single_set_globals

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
# DEPEND="doc? ( dev-python/epydoc[python_targets_python2_7(-)?,...] )"
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
					"python_single_target_${impl}(+)?"
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
# REQUIRED_USE="doc? ( ^^ ( $(python_gen_useflags 'python2*') ) )"
# @CODE
#
# It will cause the variable to look like:
# @CODE
# REQUIRED_USE="doc? ( ^^ ( python_single_target_python2_7 ) )"
# @CODE
python_gen_useflags() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl pattern
	local matches=()

	for impl in "${PYTHON_COMPAT[@]}"; do
		_python_impl_supported "${impl}" || continue

		for pattern; do
			if [[ ${impl} == ${pattern} ]]; then
				matches+=( "python_single_target_${impl}" )
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
					local usedep=$(python_gen_usedep "${@}")
					dep=${dep//\$\{PYTHON_USEDEP\}/${usedep}}
				fi

				matches+=( "python_single_target_${impl}? ( ${dep} )" )
				break
			fi
		done
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

	local impl impls=()
	for impl in "${PYTHON_COMPAT[@]}"; do
		_python_impl_supported "${impl}" || continue
		impls+=( "${impl}" )
	done

	if [[ ${#impls[@]} -eq 1 ]]; then
		if use "python_targets_${impls[0]}"; then
			# Only one supported implementation, enable it explicitly
			python_export "${impls[0]}" EPYTHON PYTHON
			python_wrapper_setup
		fi
	else
		for impl in "${impls[@]}"; do
			if use "python_single_target_${impl}"; then
				if [[ ${EPYTHON} ]]; then
					eerror "Your PYTHON_SINGLE_TARGET setting lists more than a single Python"
					eerror "implementation. Please set it to just one value. If you need"
					eerror "to override the value for a single package, please use package.env"
					eerror "or an equivalent solution (man 5 portage)."
					echo
					die "More than one implementation in PYTHON_SINGLE_TARGET."
				fi

				if ! use "python_targets_${impl}"; then
					eerror "The implementation chosen as PYTHON_SINGLE_TARGET must be added"
					eerror "to PYTHON_TARGETS as well. This is in order to ensure that"
					eerror "dependencies are satisfied correctly. We're sorry"
					eerror "for the inconvenience."
					echo
					die "Build target (${impl}) not in PYTHON_TARGETS."
				fi

				python_export "${impl}" EPYTHON PYTHON
				python_wrapper_setup
			fi
		done
	fi

	if [[ ! ${EPYTHON} ]]; then
		eerror "No Python implementation selected for the build. Please set"
		if [[ ${#impls[@]} -eq 1 ]]; then
			eerror "the PYTHON_TARGETS variable in your make.conf to include one"
		else
			eerror "the PYTHON_SINGLE_TARGET variable in your make.conf to one"
		fi
		eerror "of the following values:"
		eerror
		eerror "${impls[@]}"
		echo
		die "No supported Python implementation in PYTHON_SINGLE_TARGET/PYTHON_TARGETS."
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
