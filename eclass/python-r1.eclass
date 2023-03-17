# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: python-r1.eclass
# @MAINTAINER:
# Python team <python@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# Based on work of: Krzysztof Pawlik <nelchael@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: python-utils-r1
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
# For more information, please see the Python Guide:
# https://projects.gentoo.org/python/guide/

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_PYTHON_R1_ECLASS} ]]; then
_PYTHON_R1_ECLASS=1

if [[ ${_PYTHON_SINGLE_R1_ECLASS} ]]; then
	die 'python-r1.eclass can not be used with python-single-r1.eclass.'
elif [[ ${_PYTHON_ANY_R1_ECLASS} ]]; then
	die 'python-r1.eclass can not be used with python-any-r1.eclass.'
fi

inherit multibuild python-utils-r1

# @ECLASS_VARIABLE: PYTHON_COMPAT
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

# @ECLASS_VARIABLE: PYTHON_COMPAT_OVERRIDE
# @USER_VARIABLE
# @DEFAULT_UNSET
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

# @ECLASS_VARIABLE: PYTHON_REQ_USE
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

# @ECLASS_VARIABLE: PYTHON_DEPS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is an eclass-generated Python dependency string for all
# implementations listed in PYTHON_COMPAT.
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
# python_targets_python2_7? ( dev-lang/python:2.7[gdbm] )
# python_targets_pypy? ( dev-python/pypy[gdbm] )
# @CODE

# @ECLASS_VARIABLE: PYTHON_USEDEP
# @OUTPUT_VARIABLE
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
# python_targets_python2_7(-)?,python_targets_python3_4(-)?
# @CODE

# @ECLASS_VARIABLE: PYTHON_SINGLE_USEDEP
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# An eclass-generated USE-dependency string for the currently tested
# implementation. It is set locally for python_check_deps() call.
#
# The generated USE-flag list is compatible with packages using
# python-single-r1 eclass. For python-r1 dependencies,
# use PYTHON_USEDEP.
#
# Example use:
# @CODE
# python_check_deps() {
# 	has_version "dev-python/bar[${PYTHON_SINGLE_USEDEP}]"
# }
# @CODE
#
# Example value:
# @CODE
# python_single_target_python3_7(-)
# @CODE

# @ECLASS_VARIABLE: PYTHON_REQUIRED_USE
# @OUTPUT_VARIABLE
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
# || ( python_targets_python2_7 python_targets_python3_4 )
# @CODE

_python_set_globals() {
	local deps i PYTHON_PKG_DEP

	_python_set_impls

	for i in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		_python_export "${i}" PYTHON_PKG_DEP
		deps+="python_targets_${i}? ( ${PYTHON_PKG_DEP} ) "
	done

	local flags=( "${_PYTHON_SUPPORTED_IMPLS[@]/#/python_targets_}" )
	local optflags=${flags[@]/%/(-)?}
	local requse="|| ( ${flags[*]} )"
	local usedep=${optflags// /,}

	if [[ ${PYTHON_DEPS+1} ]]; then
		# IUSE is magical, so we can't really check it
		# (but we verify PYTHON_COMPAT already)

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

		if [[ ${PYTHON_USEDEP} != "${usedep}" ]]; then
			eerror "PYTHON_USEDEP have changed between inherits!"
			eerror "Before: ${PYTHON_USEDEP}"
			eerror "Now   : ${usedep}"
			die "PYTHON_USEDEP integrity check failed"
		fi
	else
		IUSE=${flags[*]}

		PYTHON_DEPS=${deps}
		PYTHON_REQUIRED_USE=${requse}
		PYTHON_USEDEP=${usedep}
		readonly PYTHON_DEPS PYTHON_REQUIRED_USE
	fi
}
_python_set_globals
unset -f _python_set_globals

# @FUNCTION: _python_validate_useflags
# @INTERNAL
# @DESCRIPTION:
# Enforce the proper setting of PYTHON_TARGETS, if PYTHON_COMPAT_OVERRIDE
# is not in effect. If it is, just warn that the flags will be ignored.
_python_validate_useflags() {
	debug-print-function ${FUNCNAME} "${@}"

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
		# we do not use flags with PCO
		return
	fi

	local i

	for i in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		use "python_targets_${i}" && return 0
	done

	eerror "No Python implementation selected for the build. Please add one"
	eerror "of the following values to your PYTHON_TARGETS (in make.conf):"
	eerror
	eerror "${PYTHON_COMPAT[@]}"
	echo
	die "No supported Python implementation in PYTHON_TARGETS."
}

# @FUNCTION: _python_gen_usedep
# @USAGE: [<pattern>...]
# @INTERNAL
# @DESCRIPTION:
# Output a USE dependency string for Python implementations which
# are both in PYTHON_COMPAT and match any of the patterns passed
# as parameters to the function.
#
# This is an internal function used to implement python_gen_cond_dep.
_python_gen_usedep() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl matches=()

	_python_verify_patterns "${@}"
	for impl in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		if _python_impl_matches "${impl}" "${@}"; then
			matches+=(
				"python_targets_${impl}(-)?"
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
# For the pattern syntax, please see _python_impl_matches
# in python-utils-r1.eclass.
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

	local impl matches=()

	_python_verify_patterns "${@}"
	for impl in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		if _python_impl_matches "${impl}" "${@}"; then
			matches+=( "python_targets_${impl}" )
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
# For the pattern syntax, please see _python_impl_matches
# in python-utils-r1.eclass.
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
# RDEPEND="python_targets_python2_7? (
#     dev-python/unittest2[python_targets_python2_7?] )
#	python_targets_pypy? (
#     dev-python/unittest2[python_targets_pypy?] )"
# @CODE
python_gen_cond_dep() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl matches=()
	local dep=${1}
	shift

	_python_verify_patterns "${@}"
	for impl in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		if _python_impl_matches "${impl}" "${@}"; then
			# substitute ${PYTHON_USEDEP} with USE-dep on *all* matching
			# targets, if it is used.  this ensures that Portage will
			# report all missing USE flags simultaneously rather than
			# requesting the user to enable them one by one.
			#
			# NB: the first call with replace all instances
			# of ${PYTHON_USEDEP}, so the condition will be false
			# on subsequent loop iterations and _python_gen_usedep()
			# will run at most once.
			if [[ ${dep} == *'${PYTHON_USEDEP}'* ]]; then
				local usedep=$(_python_gen_usedep "${@}")
				dep=${dep//\$\{PYTHON_USEDEP\}/${usedep}}
			fi

			matches+=( "python_targets_${impl}? ( ${dep} )" )
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
# For the pattern syntax, please see _python_impl_matches
# in python-utils-r1.eclass.
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
#   python_targets_python2_7? (
#     dev-lang/python:2.7[xml(+)] )
#	python_targets_pypy? (
#     dev-python/pypy[xml(+)] ) )"
# @CODE
python_gen_impl_dep() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl matches=()
	local PYTHON_REQ_USE=${1}
	shift

	_python_verify_patterns "${@}"
	for impl in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		if _python_impl_matches "${impl}" "${@}"; then
			local PYTHON_PKG_DEP
			_python_export "${impl}" PYTHON_PKG_DEP
			matches+=( "python_targets_${impl}? ( ${PYTHON_PKG_DEP} )" )
		fi
	done

	echo "${matches[@]}"
}

# @FUNCTION: python_gen_any_dep
# @USAGE: [<dependency-block> [<impl-pattern>...]]
# @DESCRIPTION:
# Generate an any-of dependency that enforces a version match between
# the Python interpreter and Python packages. <dependency-block> may
# list one or more dependencies with verbatim '${PYTHON_USEDEP}'
# or '${PYTHON_SINGLE_USEDEP}' references (quoted!) that will get
# expanded inside the function. If <dependency-block> is an empty string
# (or no arguments are passed), a pure dependency on any Python
# interpreter will be generated.
#
# Optionally, patterns may be specified to restrict the dependency to
# a subset of Python implementations supported by the ebuild.
# For the pattern syntax, please see _python_impl_matches
# in python-utils-r1.eclass.
#
# This should be used along with an appropriate python_check_deps()
# that checks which of the any-of blocks were matched, and python_setup
# call that enables use of the matched implementation.
#
# Example use:
# @CODE
# BDEPEND="$(python_gen_any_dep '
#	dev-python/foo[${PYTHON_SINGLE_USEDEP}]
#	|| ( dev-python/bar[${PYTHON_USEDEP}]
#		dev-python/baz[${PYTHON_USEDEP}] )' -2)"
#
# python_check_deps() {
#	has_version "dev-python/foo[${PYTHON_SINGLE_USEDEP}]" \
#		&& { has_version "dev-python/bar[${PYTHON_USEDEP}]" \
#			|| has_version "dev-python/baz[${PYTHON_USEDEP}]"; }
# }
#
# src_compile() {
#	python_foreach_impl usual_code
#
#	# some common post-build task that requires Python 2
#	python_setup -2
#	emake frobnicate
# }
# @CODE
#
# Example value:
# @CODE
# || (
#	(
#		dev-lang/python:3.7
#		dev-python/foo[python_single_target_python3_7(-)]
#		|| ( dev-python/bar[python_targets_python3_7(-),-python_single_target_python3_7(-)]
#			dev-python/baz[python_targets_python3_7(-),-python_single_target_python3_7(-)] )
#	)
#	(
#		dev-lang/python:3.8
#		dev-python/foo[python_single_target_python3_8(-)]
#		|| ( dev-python/bar[python_targets_python3_8(-)]
#			dev-python/baz[python_targets_python3_8(-)] )
#	)
# )
# @CODE
python_gen_any_dep() {
	debug-print-function ${FUNCNAME} "${@}"

	local depstr=${1}
	shift

	local i PYTHON_PKG_DEP out=
	_python_verify_patterns "${@}"
	for i in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		if _python_impl_matches "${i}" "${@}"; then
			local PYTHON_USEDEP="python_targets_${i}(-)"
			local PYTHON_SINGLE_USEDEP="python_single_target_${i}(-)"
			_python_export "${i}" PYTHON_PKG_DEP

			local i_depstr=${depstr//\$\{PYTHON_USEDEP\}/${PYTHON_USEDEP}}
			i_depstr=${i_depstr//\$\{PYTHON_SINGLE_USEDEP\}/${PYTHON_SINGLE_USEDEP}}
			# note: need to strip '=' slot operator for || deps
			out="( ${PYTHON_PKG_DEP/:0=/:0} ${i_depstr} ) ${out}"
		fi
	done
	echo "|| ( ${out})"
}

# @ECLASS_VARIABLE: BUILD_DIR
# @OUTPUT_VARIABLE
# @DEFAULT_UNSET
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
# ${WORKDIR}/foo-1.3-python2_7
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
	_python_validate_useflags

	if [[ ${PYTHON_COMPAT_OVERRIDE} ]]; then
		MULTIBUILD_VARIANTS=( ${PYTHON_COMPAT_OVERRIDE} )
		return
	fi

	MULTIBUILD_VARIANTS=()

	local impl
	for impl in "${_PYTHON_SUPPORTED_IMPLS[@]}"; do
		has "${impl}" "${PYTHON_COMPAT[@]}" && \
		use "python_targets_${impl}" && MULTIBUILD_VARIANTS+=( "${impl}" )
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
	_python_export "${MULTIBUILD_VARIANT}" EPYTHON PYTHON
	_python_wrapper_setup

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

	if [[ ${_DISTUTILS_R1_ECLASS} ]]; then
		if has "${EBUILD_PHASE}" prepare configure compile test install &&
			[[ ! ${_DISTUTILS_CALLING_FOREACH_IMPL} &&
				! ${_DISTUTILS_FOREACH_IMPL_WARNED} ]]
		then
			eqawarn "python_foreach_impl has been called directly while using distutils-r1."
			eqawarn "Please redefine python_*() phase functions to meet your expectations"
			eqawarn "instead."
			_DISTUTILS_FOREACH_IMPL_WARNED=1

			if ! has "${EAPI}" 7 8; then
				die "Calling python_foreach_impl from distutils-r1 is banned in EAPI ${EAPI}"
			fi
		fi
		# undo the eclass-set value to catch nested calls
		local _DISTUTILS_CALLING_FOREACH_IMPL=
	fi

	local MULTIBUILD_VARIANTS
	_python_obtain_impls

	multibuild_foreach_variant _python_multibuild_wrapper "${@}"
}

# @FUNCTION: python_setup
# @USAGE: [<impl-pattern>...]
# @DESCRIPTION:
# Find the best (most preferred) Python implementation that is suitable
# for running common Python code. Set the Python build environment up
# for that implementation. This function has two modes of operation:
# pure and any-of dep.
#
# The pure mode is used if python_check_deps() function is not declared.
# In this case, an implementation is considered suitable if it is
# supported (in PYTHON_COMPAT), enabled (via USE flags) and matches
# at least one of the patterns passed (or '*' if no patterns passed).
#
# Implementation restrictions in the pure mode need to be accompanied
# by appropriate REQUIRED_USE constraints. Otherwise, the eclass may
# fail at build time due to unsatisfied dependencies.
#
# The any-of dep mode is used if python_check_deps() is declared.
# In this mode, an implementation is considered suitable if it is
# supported, matches at least one of the patterns and python_check_deps()
# has successful return code. USE flags are not considered.
#
# The python_check_deps() function in the any-of mode needs to be
# accompanied by appropriate any-of dependencies.
#
# For the pattern syntax, please see _python_impl_matches
# in python-utils-r1.eclass.
#
# This function needs to be used when Python is being called outside
# of python_foreach_impl calls (e.g. for shared processes like doc
# building). python_foreach_impl sets up the build environment itself.
#
# Pure mode example:
# @CODE
# BDEPEND="doc? ( dev-python/epydoc[$(python_gen_usedep 'python2*')] )"
# REQUIRED_USE="doc? ( $(python_gen_useflags 'python2*') )"
#
# src_compile() {
#   #...
#   if use doc; then
#     python_setup 'python2*'
#     make doc
#   fi
# }
# @CODE
#
# Any-of mode example:
# @CODE
# BDEPEND="doc? (
#	$(python_gen_any_dep 'dev-python/epydoc[${PYTHON_USEDEP}]' 'python2*') )"
#
# python_check_deps() {
#	has_version "dev-python/epydoc[${PYTHON_USEDEP}]"
# }
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

	local has_check_deps
	declare -f python_check_deps >/dev/null && has_check_deps=1

	if [[ ! ${has_check_deps} ]]; then
		_python_validate_useflags
	fi

	local pycompat=( "${PYTHON_COMPAT[@]}" )
	if [[ ${PYTHON_COMPAT_OVERRIDE} ]]; then
		pycompat=( ${PYTHON_COMPAT_OVERRIDE} )
	fi

	# (reverse iteration -- newest impl first)
	local found i
	_python_verify_patterns "${@}"
	for (( i = ${#_PYTHON_SUPPORTED_IMPLS[@]} - 1; i >= 0; i-- )); do
		local impl=${_PYTHON_SUPPORTED_IMPLS[i]}

		# check PYTHON_COMPAT[_OVERRIDE]
		has "${impl}" "${pycompat[@]}" || continue

		# match USE flags only if override is not in effect
		# and python_check_deps() is not defined
		if [[ ! ${PYTHON_COMPAT_OVERRIDE} && ! ${has_check_deps} ]]; then
			use "python_targets_${impl}" || continue
		fi

		# check patterns
		_python_impl_matches "${impl}" "${@}" || continue

		_python_export "${impl}" EPYTHON PYTHON

		# if python_check_deps() is declared, switch into any-of mode
		if [[ ${has_check_deps} ]]; then
			_python_run_check_deps "${impl}" || continue
		fi

		found=1
		break
	done

	if [[ ! ${found} ]]; then
		eerror "${FUNCNAME}: none of the enabled implementation matched the patterns."
		eerror "  patterns: ${@-'(*)'}"
		eerror "Likely a REQUIRED_USE constraint (possibly USE-conditional) is missing."
		eerror "  suggested: || ( \$(python_gen_useflags ${@}) )"
		eerror "(remember to quote all the patterns with '')"
		die "${FUNCNAME}: no enabled implementation satisfy requirements"
	fi

	_python_wrapper_setup
	einfo "Using ${EPYTHON} in global scope"
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
		_python_export PYTHON_SCRIPTDIR

		(
			exeopts -m 0755
			exeinto "${PYTHON_SCRIPTDIR#${EPREFIX}}"
			doexe "${files[@]}"
		)

		python_fix_shebang -q \
			"${files[@]/*\//${D%/}/${PYTHON_SCRIPTDIR}/}"
	}

	local files=( "${@}" )
	python_foreach_impl _python_replicate_script
	unset -f _python_replicate_script

	# install the wrappers
	local f
	for f; do
		local dosym=dosym
		[[ ${EAPI} == 7 ]] && dosym=dosym8
		"${dosym}" -r /usr/lib/python-exec/python-exec2 "${f#${ED}}"
	done
}

fi
