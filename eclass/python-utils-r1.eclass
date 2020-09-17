# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: python-utils-r1.eclass
# @MAINTAINER:
# Python team <python@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# Based on work of: Krzysztof Pawlik <nelchael@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7
# @BLURB: Utility functions for packages with Python parts.
# @DESCRIPTION:
# A utility eclass providing functions to query Python implementations,
# install Python modules and scripts.
#
# This eclass does not set any metadata variables nor export any phase
# functions. It can be inherited safely.
#
# For more information, please see the Python Guide:
# https://dev.gentoo.org/~mgorny/python-guide/

case "${EAPI:-0}" in
	[0-4]) die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}" ;;
	[5-7]) ;;
	*)     die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}" ;;
esac

if [[ ${_PYTHON_ECLASS_INHERITED} ]]; then
	die 'python-r1 suite eclasses can not be used with python.eclass.'
fi

if [[ ! ${_PYTHON_UTILS_R1} ]]; then

[[ ${EAPI} == 5 ]] && inherit eutils multilib
inherit toolchain-funcs

# @ECLASS-VARIABLE: _PYTHON_ALL_IMPLS
# @INTERNAL
# @DESCRIPTION:
# All supported Python implementations, most preferred last.
_PYTHON_ALL_IMPLS=(
	pypy3
	python2_7
	python3_6 python3_7 python3_8 python3_9
)
readonly _PYTHON_ALL_IMPLS

# @ECLASS-VARIABLE: _PYTHON_HISTORICAL_IMPLS
# @INTERNAL
# @DESCRIPTION:
# All historical Python implementations that are no longer supported.
_PYTHON_HISTORICAL_IMPLS=(
	jython2_7
	pypy pypy1_{8,9} pypy2_0
	python2_{5,6}
	python3_{1,2,3,4,5}
)
readonly _PYTHON_HISTORICAL_IMPLS

# @ECLASS-VARIABLE: PYTHON_COMPAT_NO_STRICT
# @INTERNAL
# @DESCRIPTION:
# Set to a non-empty value in order to make eclass tolerate (ignore)
# unknown implementations in PYTHON_COMPAT.
#
# This is intended to be set by the user when using ebuilds that may
# have unknown (newer) implementations in PYTHON_COMPAT. The assumption
# is that the ebuilds are intended to be used within multiple contexts
# which can involve revisions of this eclass that support a different
# set of Python implementations.

# @FUNCTION: _python_impl_supported
# @USAGE: <impl>
# @INTERNAL
# @DESCRIPTION:
# Check whether the implementation <impl> (PYTHON_COMPAT-form)
# is still supported.
#
# Returns 0 if the implementation is valid and supported. If it is
# unsupported, returns 1 -- and the caller should ignore the entry.
# If it is invalid, dies with an appopriate error messages.
_python_impl_supported() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 1 ]] || die "${FUNCNAME}: takes exactly 1 argument (impl)."

	local impl=${1}

	# keep in sync with _PYTHON_ALL_IMPLS!
	# (not using that list because inline patterns shall be faster)
	case "${impl}" in
		python2_7|python3_[6789]|pypy3)
			return 0
			;;
		jython2_7|pypy|pypy1_[89]|pypy2_0|python2_[56]|python3_[12345])
			return 1
			;;
		*)
			[[ ${PYTHON_COMPAT_NO_STRICT} ]] && return 1
			die "Invalid implementation in PYTHON_COMPAT: ${impl}"
	esac
}

# @FUNCTION: _python_verify_patterns
# @USAGE: <pattern>...
# @INTERNAL
# @DESCRIPTION:
# Verify whether the patterns passed to the eclass function are correct
# (i.e. can match any valid implementation).  Dies on wrong pattern.
_python_verify_patterns() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl pattern
	for pattern; do
		[[ ${pattern} == -[23] ]] && continue

		for impl in "${_PYTHON_ALL_IMPLS[@]}" "${_PYTHON_HISTORICAL_IMPLS[@]}"
		do
			[[ ${impl} == ${pattern/./_} ]] && continue 2
		done

		die "Invalid implementation pattern: ${pattern}"
	done
}

# @FUNCTION: _python_set_impls
# @INTERNAL
# @DESCRIPTION:
# Check PYTHON_COMPAT for well-formedness and validity, then set
# two global variables:
#
# - _PYTHON_SUPPORTED_IMPLS containing valid implementations supported
#   by the ebuild (PYTHON_COMPAT - dead implementations),
#
# - and _PYTHON_UNSUPPORTED_IMPLS containing valid implementations that
#   are not supported by the ebuild.
#
# Implementations in both variables are ordered using the pre-defined
# eclass implementation ordering.
#
# This function must be called once in global scope by an eclass
# utilizing PYTHON_COMPAT.
_python_set_impls() {
	local i

	if ! declare -p PYTHON_COMPAT &>/dev/null; then
		die 'PYTHON_COMPAT not declared.'
	fi
	if [[ $(declare -p PYTHON_COMPAT) != "declare -a"* ]]; then
		die 'PYTHON_COMPAT must be an array.'
	fi
	for i in "${PYTHON_COMPAT[@]}"; do
		# trigger validity checks
		_python_impl_supported "${i}"
	done

	local supp=() unsupp=()

	for i in "${_PYTHON_ALL_IMPLS[@]}"; do
		if has "${i}" "${PYTHON_COMPAT[@]}"; then
			supp+=( "${i}" )
		else
			unsupp+=( "${i}" )
		fi
	done

	if [[ ! ${supp[@]} ]]; then
		die "No supported implementation in PYTHON_COMPAT."
	fi

	if [[ ${_PYTHON_SUPPORTED_IMPLS[@]} ]]; then
		# set once already, verify integrity
		if [[ ${_PYTHON_SUPPORTED_IMPLS[@]} != ${supp[@]} ]]; then
			eerror "Supported impls (PYTHON_COMPAT) changed between inherits!"
			eerror "Before: ${_PYTHON_SUPPORTED_IMPLS[*]}"
			eerror "Now   : ${supp[*]}"
			die "_PYTHON_SUPPORTED_IMPLS integrity check failed"
		fi
		if [[ ${_PYTHON_UNSUPPORTED_IMPLS[@]} != ${unsupp[@]} ]]; then
			eerror "Unsupported impls changed between inherits!"
			eerror "Before: ${_PYTHON_UNSUPPORTED_IMPLS[*]}"
			eerror "Now   : ${unsupp[*]}"
			die "_PYTHON_UNSUPPORTED_IMPLS integrity check failed"
		fi
	else
		_PYTHON_SUPPORTED_IMPLS=( "${supp[@]}" )
		_PYTHON_UNSUPPORTED_IMPLS=( "${unsupp[@]}" )
		readonly _PYTHON_SUPPORTED_IMPLS _PYTHON_UNSUPPORTED_IMPLS
	fi
}

# @FUNCTION: _python_impl_matches
# @USAGE: <impl> [<pattern>...]
# @INTERNAL
# @DESCRIPTION:
# Check whether the specified <impl> matches at least one
# of the patterns following it. Return 0 if it does, 1 otherwise.
# Matches if no patterns are provided.
#
# <impl> can be in PYTHON_COMPAT or EPYTHON form. The patterns can be
# either:
# a) fnmatch-style patterns, e.g. 'python2*', 'pypy'...
# b) '-2' to indicate all Python 2 variants (= !python_is_python3)
# c) '-3' to indicate all Python 3 variants (= python_is_python3)
_python_impl_matches() {
	[[ ${#} -ge 1 ]] || die "${FUNCNAME}: takes at least 1 parameter"
	[[ ${#} -eq 1 ]] && return 0

	local impl=${1} pattern
	shift

	for pattern; do
		if [[ ${pattern} == -2 ]]; then
			python_is_python3 "${impl}" || return 0
		elif [[ ${pattern} == -3 ]]; then
			python_is_python3 "${impl}" && return 0
			return
		# unify value style to allow lax matching
		elif [[ ${impl/./_} == ${pattern/./_} ]]; then
			return 0
		fi
	done

	return 1
}

# @ECLASS-VARIABLE: PYTHON
# @DEFAULT_UNSET
# @DESCRIPTION:
# The absolute path to the current Python interpreter.
#
# This variable is set automatically in the following contexts:
#
# python-r1: Set in functions called by python_foreach_impl() or after
# calling python_setup().
#
# python-single-r1: Set after calling python-single-r1_pkg_setup().
#
# distutils-r1: Set within any of the python sub-phase functions.
#
# Example value:
# @CODE
# /usr/bin/python2.7
# @CODE

# @ECLASS-VARIABLE: EPYTHON
# @DEFAULT_UNSET
# @DESCRIPTION:
# The executable name of the current Python interpreter.
#
# This variable is set automatically in the following contexts:
#
# python-r1: Set in functions called by python_foreach_impl() or after
# calling python_setup().
#
# python-single-r1: Set after calling python-single-r1_pkg_setup().
#
# distutils-r1: Set within any of the python sub-phase functions.
#
# Example value:
# @CODE
# python2.7
# @CODE

# @FUNCTION: python_export
# @USAGE: [<impl>] <variables>...
# @INTERNAL
# @DESCRIPTION:
# Backwards compatibility function.  The relevant API is now considered
# private, please use python_get* instead.
python_export() {
	debug-print-function ${FUNCNAME} "${@}"

	eqawarn "python_export() is part of private eclass API."
	eqawarn "Please call python_get*() instead."

	_python_export "${@}"
}

# @FUNCTION: _python_export
# @USAGE: [<impl>] <variables>...
# @INTERNAL
# @DESCRIPTION:
# Set and export the Python implementation-relevant variables passed
# as parameters.
#
# The optional first parameter may specify the requested Python
# implementation (either as PYTHON_TARGETS value, e.g. python2_7,
# or an EPYTHON one, e.g. python2.7). If no implementation passed,
# the current one will be obtained from ${EPYTHON}.
#
# The variables which can be exported are: PYTHON, EPYTHON,
# PYTHON_SITEDIR. They are described more completely in the eclass
# variable documentation.
_python_export() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl var

	case "${1}" in
		python*|jython*)
			impl=${1/_/.}
			shift
			;;
		pypy|pypy3)
			impl=${1}
			shift
			;;
		*)
			impl=${EPYTHON}
			if [[ -z ${impl} ]]; then
				die "_python_export called without a python implementation and EPYTHON is unset"
			fi
			;;
	esac
	debug-print "${FUNCNAME}: implementation: ${impl}"

	for var; do
		case "${var}" in
			EPYTHON)
				export EPYTHON=${impl}
				debug-print "${FUNCNAME}: EPYTHON = ${EPYTHON}"
				;;
			PYTHON)
				export PYTHON=${EPREFIX}/usr/bin/${impl}
				debug-print "${FUNCNAME}: PYTHON = ${PYTHON}"
				;;
			PYTHON_SITEDIR)
				[[ -n ${PYTHON} ]] || die "PYTHON needs to be set for ${var} to be exported, or requested before it"
				# sysconfig can't be used because:
				# 1) pypy doesn't give site-packages but stdlib
				# 2) jython gives paths with wrong case
				PYTHON_SITEDIR=$("${PYTHON}" -c 'import distutils.sysconfig; print(distutils.sysconfig.get_python_lib())') || die
				export PYTHON_SITEDIR
				debug-print "${FUNCNAME}: PYTHON_SITEDIR = ${PYTHON_SITEDIR}"
				;;
			PYTHON_INCLUDEDIR)
				[[ -n ${PYTHON} ]] || die "PYTHON needs to be set for ${var} to be exported, or requested before it"
				PYTHON_INCLUDEDIR=$("${PYTHON}" -c 'import distutils.sysconfig; print(distutils.sysconfig.get_python_inc())') || die
				export PYTHON_INCLUDEDIR
				debug-print "${FUNCNAME}: PYTHON_INCLUDEDIR = ${PYTHON_INCLUDEDIR}"

				# Jython gives a non-existing directory
				if [[ ! -d ${PYTHON_INCLUDEDIR} ]]; then
					die "${impl} does not install any header files!"
				fi
				;;
			PYTHON_LIBPATH)
				[[ -n ${PYTHON} ]] || die "PYTHON needs to be set for ${var} to be exported, or requested before it"
				PYTHON_LIBPATH=$("${PYTHON}" -c 'import os.path, sysconfig; print(os.path.join(sysconfig.get_config_var("LIBDIR"), sysconfig.get_config_var("LDLIBRARY")) if sysconfig.get_config_var("LDLIBRARY") else "")') || die
				export PYTHON_LIBPATH
				debug-print "${FUNCNAME}: PYTHON_LIBPATH = ${PYTHON_LIBPATH}"

				if [[ ! ${PYTHON_LIBPATH} ]]; then
					die "${impl} lacks a (usable) dynamic library"
				fi
				;;
			PYTHON_CFLAGS)
				local val

				case "${impl}" in
					python*)
						# python-2.7, python-3.2, etc.
						val=$($(tc-getPKG_CONFIG) --cflags ${impl/n/n-}) || die
						;;
					*)
						die "${impl}: obtaining ${var} not supported"
						;;
				esac

				export PYTHON_CFLAGS=${val}
				debug-print "${FUNCNAME}: PYTHON_CFLAGS = ${PYTHON_CFLAGS}"
				;;
			PYTHON_LIBS)
				local val

				case "${impl}" in
					python2*|python3.6|python3.7*)
						# python* up to 3.7
						val=$($(tc-getPKG_CONFIG) --libs ${impl/n/n-}) || die
						;;
					python*)
						# python3.8+
						val=$($(tc-getPKG_CONFIG) --libs ${impl/n/n-}-embed) || die
						;;
					*)
						die "${impl}: obtaining ${var} not supported"
						;;
				esac

				export PYTHON_LIBS=${val}
				debug-print "${FUNCNAME}: PYTHON_LIBS = ${PYTHON_LIBS}"
				;;
			PYTHON_CONFIG)
				local flags val

				case "${impl}" in
					python*)
						[[ -n ${PYTHON} ]] || die "PYTHON needs to be set for ${var} to be exported, or requested before it"
						flags=$("${PYTHON}" -c 'import sysconfig; print(sysconfig.get_config_var("ABIFLAGS") or "")') || die
						val=${PYTHON}${flags}-config
						;;
					*)
						die "${impl}: obtaining ${var} not supported"
						;;
				esac

				export PYTHON_CONFIG=${val}
				debug-print "${FUNCNAME}: PYTHON_CONFIG = ${PYTHON_CONFIG}"
				;;
			PYTHON_PKG_DEP)
				local d
				case ${impl} in
					python2.7)
						PYTHON_PKG_DEP='>=dev-lang/python-2.7.5-r2:2.7';;
					python*)
						PYTHON_PKG_DEP="dev-lang/python:${impl#python}";;
					pypy)
						PYTHON_PKG_DEP='>=dev-python/pypy-7.3.0:0=';;
					pypy3)
						PYTHON_PKG_DEP='>=dev-python/pypy3-7.3.0:0=';;
					*)
						die "Invalid implementation: ${impl}"
				esac

				# use-dep
				if [[ ${PYTHON_REQ_USE} ]]; then
					PYTHON_PKG_DEP+=[${PYTHON_REQ_USE}]
				fi

				export PYTHON_PKG_DEP
				debug-print "${FUNCNAME}: PYTHON_PKG_DEP = ${PYTHON_PKG_DEP}"
				;;
			PYTHON_SCRIPTDIR)
				local dir
				export PYTHON_SCRIPTDIR=${EPREFIX}/usr/lib/python-exec/${impl}
				debug-print "${FUNCNAME}: PYTHON_SCRIPTDIR = ${PYTHON_SCRIPTDIR}"
				;;
			*)
				die "_python_export: unknown variable ${var}"
		esac
	done
}

# @FUNCTION: python_get_sitedir
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the 'site-packages' path for the given
# implementation. If no implementation is provided, ${EPYTHON} will
# be used.
python_get_sitedir() {
	debug-print-function ${FUNCNAME} "${@}"

	_python_export "${@}" PYTHON_SITEDIR
	echo "${PYTHON_SITEDIR}"
}

# @FUNCTION: python_get_includedir
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the include path for the given implementation. If no
# implementation is provided, ${EPYTHON} will be used.
python_get_includedir() {
	debug-print-function ${FUNCNAME} "${@}"

	_python_export "${@}" PYTHON_INCLUDEDIR
	echo "${PYTHON_INCLUDEDIR}"
}

# @FUNCTION: python_get_library_path
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the Python library path for the given implementation.
# If no implementation is provided, ${EPYTHON} will be used.
#
# Please note that this function can be used with CPython only. Use
# in another implementation will result in a fatal failure.
python_get_library_path() {
	debug-print-function ${FUNCNAME} "${@}"

	_python_export "${@}" PYTHON_LIBPATH
	echo "${PYTHON_LIBPATH}"
}

# @FUNCTION: python_get_CFLAGS
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the compiler flags for building against Python,
# for the given implementation. If no implementation is provided,
# ${EPYTHON} will be used.
#
# Please note that this function can be used with CPython only.
# It requires Python and pkg-config installed, and therefore proper
# build-time dependencies need be added to the ebuild.
python_get_CFLAGS() {
	debug-print-function ${FUNCNAME} "${@}"

	_python_export "${@}" PYTHON_CFLAGS
	echo "${PYTHON_CFLAGS}"
}

# @FUNCTION: python_get_LIBS
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the compiler flags for linking against Python,
# for the given implementation. If no implementation is provided,
# ${EPYTHON} will be used.
#
# Please note that this function can be used with CPython only.
# It requires Python and pkg-config installed, and therefore proper
# build-time dependencies need be added to the ebuild.
python_get_LIBS() {
	debug-print-function ${FUNCNAME} "${@}"

	_python_export "${@}" PYTHON_LIBS
	echo "${PYTHON_LIBS}"
}

# @FUNCTION: python_get_PYTHON_CONFIG
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the PYTHON_CONFIG location for the given
# implementation. If no implementation is provided, ${EPYTHON} will be
# used.
#
# Please note that this function can be used with CPython only.
# It requires Python installed, and therefore proper build-time
# dependencies need be added to the ebuild.
python_get_PYTHON_CONFIG() {
	debug-print-function ${FUNCNAME} "${@}"

	_python_export "${@}" PYTHON_CONFIG
	echo "${PYTHON_CONFIG}"
}

# @FUNCTION: python_get_scriptdir
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the script install path for the given
# implementation. If no implementation is provided, ${EPYTHON} will
# be used.
python_get_scriptdir() {
	debug-print-function ${FUNCNAME} "${@}"

	_python_export "${@}" PYTHON_SCRIPTDIR
	echo "${PYTHON_SCRIPTDIR}"
}

# @FUNCTION: _python_ln_rel
# @USAGE: <from> <to>
# @INTERNAL
# @DESCRIPTION:
# Create a relative symlink.
_python_ln_rel() {
	debug-print-function ${FUNCNAME} "${@}"

	local target=${1}
	local symname=${2}

	local tgpath=${target%/*}/
	local sympath=${symname%/*}/
	local rel_target=

	while [[ ${sympath} ]]; do
		local tgseg= symseg=

		while [[ ! ${tgseg} && ${tgpath} ]]; do
			tgseg=${tgpath%%/*}
			tgpath=${tgpath#${tgseg}/}
		done

		while [[ ! ${symseg} && ${sympath} ]]; do
			symseg=${sympath%%/*}
			sympath=${sympath#${symseg}/}
		done

		if [[ ${tgseg} != ${symseg} ]]; then
			rel_target=../${rel_target}${tgseg:+${tgseg}/}
		fi
	done
	rel_target+=${tgpath}${target##*/}

	debug-print "${FUNCNAME}: ${symname} -> ${target}"
	debug-print "${FUNCNAME}: rel_target = ${rel_target}"

	ln -fs "${rel_target}" "${symname}"
}

# @FUNCTION: python_optimize
# @USAGE: [<directory>...]
# @DESCRIPTION:
# Compile and optimize Python modules in specified directories (absolute
# paths). If no directories are provided, the default system paths
# are used (prepended with ${D}).
python_optimize() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ ${EBUILD_PHASE} == pre* || ${EBUILD_PHASE} == post* ]]; then
		eerror "The new Python eclasses expect the compiled Python files to"
		eerror "be controlled by the Package Manager. For this reason,"
		eerror "the python_optimize function can be used only during src_* phases"
		eerror "(src_install most commonly) and not during pkg_* phases."
		echo
		die "python_optimize is not to be used in pre/post* phases"
	fi

	[[ ${EPYTHON} ]] || die 'No Python implementation set (EPYTHON is null).'

	local PYTHON=${PYTHON}
	[[ ${PYTHON} ]] || _python_export PYTHON
	[[ -x ${PYTHON} ]] || die "PYTHON (${PYTHON}) is not executable"

	# default to sys.path
	if [[ ${#} -eq 0 ]]; then
		local f
		while IFS= read -r -d '' f; do
			# 1) accept only absolute paths
			#    (i.e. skip '', '.' or anything like that)
			# 2) skip paths which do not exist
			#    (python2.6 complains about them verbosely)

			if [[ ${f} == /* && -d ${D%/}${f} ]]; then
				set -- "${D%/}${f}" "${@}"
			fi
		done < <("${PYTHON}" -c 'import sys; print("".join(x + "\0" for x in sys.path))' || die)

		debug-print "${FUNCNAME}: using sys.path: ${*/%/;}"
	fi

	local d
	for d; do
		# make sure to get a nice path without //
		local instpath=${d#${D%/}}
		instpath=/${instpath##/}

		case "${EPYTHON}" in
			python2.7|python3.[34])
				"${PYTHON}" -m compileall -q -f -d "${instpath}" "${d}"
				"${PYTHON}" -OO -m compileall -q -f -d "${instpath}" "${d}"
				;;
			python*|pypy3)
				# both levels of optimization are separate since 3.5
				"${PYTHON}" -m compileall -q -f -d "${instpath}" "${d}"
				"${PYTHON}" -O -m compileall -q -f -d "${instpath}" "${d}"
				"${PYTHON}" -OO -m compileall -q -f -d "${instpath}" "${d}"
				;;
			*)
				"${PYTHON}" -m compileall -q -f -d "${instpath}" "${d}"
				;;
		esac
	done
}

# @FUNCTION: python_scriptinto
# @USAGE: <new-path>
# @DESCRIPTION:
# Set the directory to which files passed to python_doexe(),
# python_doscript(), python_newexe() and python_newscript()
# are going to be installed. The new value needs to be relative
# to the installation root (${ED}).
#
# If not set explicitly, the directory defaults to /usr/bin.
#
# Example:
# @CODE
# src_install() {
#   python_scriptinto /usr/sbin
#   python_foreach_impl python_doscript foo
# }
# @CODE
python_scriptinto() {
	debug-print-function ${FUNCNAME} "${@}"

	python_scriptroot=${1}
}

# @FUNCTION: python_doexe
# @USAGE: <files>...
# @DESCRIPTION:
# Install the given executables into the executable install directory,
# for the current Python implementation (${EPYTHON}).
#
# The executable will be wrapped properly for the Python implementation,
# though no shebang mangling will be performed.
python_doexe() {
	debug-print-function ${FUNCNAME} "${@}"

	local f
	for f; do
		python_newexe "${f}" "${f##*/}"
	done
}

# @FUNCTION: python_newexe
# @USAGE: <path> <new-name>
# @DESCRIPTION:
# Install the given executable into the executable install directory,
# for the current Python implementation (${EPYTHON}).
#
# The executable will be wrapped properly for the Python implementation,
# though no shebang mangling will be performed. It will be renamed
# to <new-name>.
python_newexe() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${EPYTHON} ]] || die 'No Python implementation set (EPYTHON is null).'
	[[ ${#} -eq 2 ]] || die "Usage: ${FUNCNAME} <path> <new-name>"

	local wrapd=${python_scriptroot:-/usr/bin}

	local f=${1}
	local newfn=${2}

	local scriptdir=$(python_get_scriptdir)
	local d=${scriptdir#${EPREFIX}}

	(
		dodir "${wrapd}"
		exeopts -m 0755
		exeinto "${d}"
		newexe "${f}" "${newfn}" || return ${?}
	)

	# install the wrapper
	_python_ln_rel "${ED%/}"/usr/lib/python-exec/python-exec2 \
		"${ED%/}/${wrapd}/${newfn}" || die

	# don't use this at home, just call python_doscript() instead
	if [[ ${_PYTHON_REWRITE_SHEBANG} ]]; then
		python_fix_shebang -q "${ED%/}/${d}/${newfn}"
	fi
}

# @FUNCTION: python_doscript
# @USAGE: <files>...
# @DESCRIPTION:
# Install the given scripts into the executable install directory,
# for the current Python implementation (${EPYTHON}).
#
# All specified files must start with a 'python' shebang. The shebang
# will be converted, and the files will be wrapped properly
# for the Python implementation.
#
# Example:
# @CODE
# src_install() {
#   python_foreach_impl python_doscript ${PN}
# }
# @CODE
python_doscript() {
	debug-print-function ${FUNCNAME} "${@}"

	local _PYTHON_REWRITE_SHEBANG=1
	python_doexe "${@}"
}

# @FUNCTION: python_newscript
# @USAGE: <path> <new-name>
# @DESCRIPTION:
# Install the given script into the executable install directory
# for the current Python implementation (${EPYTHON}), and name it
# <new-name>.
#
# The file must start with a 'python' shebang. The shebang will be
# converted, and the file will be wrapped properly for the Python
# implementation. It will be renamed to <new-name>.
#
# Example:
# @CODE
# src_install() {
#   python_foreach_impl python_newscript foo.py foo
# }
# @CODE
python_newscript() {
	debug-print-function ${FUNCNAME} "${@}"

	local _PYTHON_REWRITE_SHEBANG=1
	python_newexe "${@}"
}

# @FUNCTION: python_moduleinto
# @USAGE: <new-path>
# @DESCRIPTION:
# Set the Python module install directory for python_domodule().
# The <new-path> can either be an absolute target system path (in which
# case it needs to start with a slash, and ${ED} will be prepended to
# it) or relative to the implementation's site-packages directory
# (then it must not start with a slash). The relative path can be
# specified either using the Python package notation (separated by dots)
# or the directory notation (using slashes).
#
# When not set explicitly, the modules are installed to the top
# site-packages directory.
#
# In the relative case, the exact path is determined directly
# by each python_doscript/python_newscript function. Therefore,
# python_moduleinto can be safely called before establishing the Python
# interpreter and/or a single call can be used to set the path correctly
# for multiple implementations, as can be seen in the following example.
#
# Example:
# @CODE
# src_install() {
#   python_moduleinto bar
#   # installs ${PYTHON_SITEDIR}/bar/baz.py
#   python_foreach_impl python_domodule baz.py
# }
# @CODE
python_moduleinto() {
	debug-print-function ${FUNCNAME} "${@}"

	python_moduleroot=${1}
}

# @FUNCTION: python_domodule
# @USAGE: <files>...
# @DESCRIPTION:
# Install the given modules (or packages) into the current Python module
# installation directory. The list can mention both modules (files)
# and packages (directories). All listed files will be installed
# for all enabled implementations, and compiled afterwards.
#
# Example:
# @CODE
# src_install() {
#   # (${PN} being a directory)
#   python_foreach_impl python_domodule ${PN}
# }
# @CODE
python_domodule() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${EPYTHON} ]] || die 'No Python implementation set (EPYTHON is null).'

	local d
	if [[ ${python_moduleroot} == /* ]]; then
		# absolute path
		d=${python_moduleroot}
	else
		# relative to site-packages
		local sitedir=$(python_get_sitedir)
		d=${sitedir#${EPREFIX}}/${python_moduleroot//.//}
	fi

	(
		insopts -m 0644
		insinto "${d}"
		doins -r "${@}" || return ${?}
	)

	python_optimize "${ED%/}/${d}"
}

# @FUNCTION: python_doheader
# @USAGE: <files>...
# @DESCRIPTION:
# Install the given headers into the implementation-specific include
# directory. This function is unconditionally recursive, i.e. you can
# pass directories instead of files.
#
# Example:
# @CODE
# src_install() {
#   python_foreach_impl python_doheader foo.h bar.h
# }
# @CODE
python_doheader() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${EPYTHON} ]] || die 'No Python implementation set (EPYTHON is null).'

	local includedir=$(python_get_includedir)
	local d=${includedir#${EPREFIX}}

	(
		insopts -m 0644
		insinto "${d}"
		doins -r "${@}" || return ${?}
	)
}

# @FUNCTION: python_wrapper_setup
# @USAGE: [<path> [<impl>]]
# @DESCRIPTION:
# Backwards compatibility function.  The relevant API is now considered
# private, please use python_setup instead.
python_wrapper_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	eqawarn "python_wrapper_setup() is part of private eclass API."
	eqawarn "Please call python_setup() instead."

	_python_wrapper_setup "${@}"
}

# @FUNCTION: _python_wrapper_setup
# @USAGE: [<path> [<impl>]]
# @INTERNAL
# @DESCRIPTION:
# Create proper 'python' executable and pkg-config wrappers
# (if available) in the directory named by <path>. Set up PATH
# and PKG_CONFIG_PATH appropriately. <path> defaults to ${T}/${EPYTHON}.
#
# The wrappers will be created for implementation named by <impl>,
# or for one named by ${EPYTHON} if no <impl> passed.
#
# If the named directory contains a python symlink already, it will
# be assumed to contain proper wrappers already and only environment
# setup will be done. If wrapper update is requested, the directory
# shall be removed first.
_python_wrapper_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	local workdir=${1:-${T}/${EPYTHON}}
	local impl=${2:-${EPYTHON}}

	[[ ${workdir} ]] || die "${FUNCNAME}: no workdir specified."
	[[ ${impl} ]] || die "${FUNCNAME}: no impl nor EPYTHON specified."

	if [[ ! -x ${workdir}/bin/python ]]; then
		_python_check_dead_variables

		mkdir -p "${workdir}"/{bin,pkgconfig} || die

		# Clean up, in case we were supposed to do a cheap update.
		rm -f "${workdir}"/bin/python{,2,3}{,-config} || die
		rm -f "${workdir}"/bin/2to3 || die
		rm -f "${workdir}"/pkgconfig/python{2,3}{,-embed}.pc || die

		local EPYTHON PYTHON
		_python_export "${impl}" EPYTHON PYTHON

		local pyver pyother
		if python_is_python3; then
			pyver=3
			pyother=2
		else
			pyver=2
			pyother=3
		fi

		# Python interpreter
		# note: we don't use symlinks because python likes to do some
		# symlink reading magic that breaks stuff
		# https://bugs.gentoo.org/show_bug.cgi?id=555752
		cat > "${workdir}/bin/python" <<-_EOF_ || die
			#!/bin/sh
			exec "${PYTHON}" "\${@}"
		_EOF_
		cp "${workdir}/bin/python" "${workdir}/bin/python${pyver}" || die
		chmod +x "${workdir}/bin/python" "${workdir}/bin/python${pyver}" || die

		local nonsupp=( "python${pyother}" "python${pyother}-config" )

		# CPython-specific
		if [[ ${EPYTHON} == python* ]]; then
			cat > "${workdir}/bin/python-config" <<-_EOF_ || die
				#!/bin/sh
				exec "${PYTHON}-config" "\${@}"
			_EOF_
			cp "${workdir}/bin/python-config" \
				"${workdir}/bin/python${pyver}-config" || die
			chmod +x "${workdir}/bin/python-config" \
				"${workdir}/bin/python${pyver}-config" || die

			# Python 2.6+.
			ln -s "${PYTHON/python/2to3-}" "${workdir}"/bin/2to3 || die

			# Python 2.7+.
			ln -s "${EPREFIX}"/usr/$(get_libdir)/pkgconfig/${EPYTHON/n/n-}.pc \
				"${workdir}"/pkgconfig/python${pyver}.pc || die

			# Python 3.8+.
			if [[ ${EPYTHON} != python[23].[67] ]]; then
				ln -s "${EPREFIX}"/usr/$(get_libdir)/pkgconfig/${EPYTHON/n/n-}-embed.pc \
					"${workdir}"/pkgconfig/python${pyver}-embed.pc || die
			fi
		else
			nonsupp+=( 2to3 python-config "python${pyver}-config" )
		fi

		local x
		for x in "${nonsupp[@]}"; do
			cat >"${workdir}"/bin/${x} <<-_EOF_ || die
				#!/bin/sh
				echo "${ECLASS}: ${FUNCNAME}: ${x} is not supported by ${EPYTHON} (PYTHON_COMPAT)" >&2
				exit 127
			_EOF_
			chmod +x "${workdir}"/bin/${x} || die
		done
	fi

	# Now, set the environment.
	# But note that ${workdir} may be shared with something else,
	# and thus already on top of PATH.
	if [[ ${PATH##:*} != ${workdir}/bin ]]; then
		PATH=${workdir}/bin${PATH:+:${PATH}}
	fi
	if [[ ${PKG_CONFIG_PATH##:*} != ${workdir}/pkgconfig ]]; then
		PKG_CONFIG_PATH=${workdir}/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}
	fi
	export PATH PKG_CONFIG_PATH
}

# @FUNCTION: python_is_python3
# @USAGE: [<impl>]
# @DESCRIPTION:
# Check whether <impl> (or ${EPYTHON}) is a Python3k variant
# (i.e. uses syntax and stdlib of Python 3.*).
#
# Returns 0 (true) if it is, 1 (false) otherwise.
python_is_python3() {
	local impl=${1:-${EPYTHON}}
	[[ ${impl} ]] || die "python_is_python3: no impl nor EPYTHON"

	[[ ${impl} == python3* || ${impl} == pypy3 ]]
}

# @FUNCTION: python_is_installed
# @USAGE: [<impl>]
# @DESCRIPTION:
# Check whether the interpreter for <impl> (or ${EPYTHON}) is installed.
# Uses has_version with a proper dependency string.
#
# Returns 0 (true) if it is, 1 (false) otherwise.
python_is_installed() {
	local impl=${1:-${EPYTHON}}
	[[ ${impl} ]] || die "${FUNCNAME}: no impl nor EPYTHON"
	local hasv_args=()

	case ${EAPI} in
		5|6)
			hasv_args+=( --host-root )
			;;
		*)
			hasv_args+=( -b )
			;;
	esac

	local PYTHON_PKG_DEP
	_python_export "${impl}" PYTHON_PKG_DEP
	has_version "${hasv_args[@]}" "${PYTHON_PKG_DEP}"
}

# @FUNCTION: python_fix_shebang
# @USAGE: [-f|--force] [-q|--quiet] <path>...
# @DESCRIPTION:
# Replace the shebang in Python scripts with the current Python
# implementation (EPYTHON). If a directory is passed, works recursively
# on all Python scripts.
#
# Only files having a 'python*' shebang will be modified. Files with
# other shebang will either be skipped when working recursively
# on a directory or treated as error when specified explicitly.
#
# Shebangs matching explicitly current Python version will be left
# unmodified. Shebangs requesting another Python version will be treated
# as fatal error, unless --force is given.
#
# --force causes the function to replace even shebangs that require
# incompatible Python version. --quiet causes the function not to list
# modified files verbosely.
python_fix_shebang() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${EPYTHON} ]] || die "${FUNCNAME}: EPYTHON unset (pkg_setup not called?)"

	local force quiet
	while [[ ${@} ]]; do
		case "${1}" in
			-f|--force) force=1; shift;;
			-q|--quiet) quiet=1; shift;;
			--) shift; break;;
			*) break;;
		esac
	done

	[[ ${1} ]] || die "${FUNCNAME}: no paths given"

	local path f
	for path; do
		local any_correct any_fixed is_recursive

		[[ -d ${path} ]] && is_recursive=1

		while IFS= read -r -d '' f; do
			local shebang i
			local error= from=

			# note: we can't ||die here since read will fail if file
			# has no newline characters
			IFS= read -r shebang <"${f}"

			# First, check if it's shebang at all...
			if [[ ${shebang} == '#!'* ]]; then
				local split_shebang=()
				read -r -a split_shebang <<<${shebang} || die

				# Match left-to-right in a loop, to avoid matching random
				# repetitions like 'python2.7 python2'.
				for i in "${split_shebang[@]}"; do
					case "${i}" in
						*"${EPYTHON}")
							debug-print "${FUNCNAME}: in file ${f#${D%/}}"
							debug-print "${FUNCNAME}: shebang matches EPYTHON: ${shebang}"

							# Nothing to do, move along.
							any_correct=1
							from=${EPYTHON}
							break
							;;
						*python|*python[23])
							debug-print "${FUNCNAME}: in file ${f#${D%/}}"
							debug-print "${FUNCNAME}: rewriting shebang: ${shebang}"

							if [[ ${i} == *python2 ]]; then
								from=python2
								if [[ ! ${force} ]]; then
									python_is_python3 "${EPYTHON}" && error=1
								fi
							elif [[ ${i} == *python3 ]]; then
								from=python3
								if [[ ! ${force} ]]; then
									python_is_python3 "${EPYTHON}" || error=1
								fi
							else
								from=python
							fi
							break
							;;
						*python[23].[0123456789]|*pypy|*pypy3|*jython[23].[0123456789])
							# Explicit mismatch.
							if [[ ! ${force} ]]; then
								error=1
							else
								case "${i}" in
									*python[23].[0123456789])
										from="python[23].[0123456789]";;
									*pypy)
										from="pypy";;
									*pypy3)
										from="pypy3";;
									*jython[23].[0123456789])
										from="jython[23].[0123456789]";;
									*)
										die "${FUNCNAME}: internal error in 2nd pattern match";;
								esac
							fi
							break
							;;
					esac
				done
			fi

			if [[ ! ${error} && ! ${from} ]]; then
				# Non-Python shebang. Allowed in recursive mode,
				# disallowed when specifying file explicitly.
				[[ ${is_recursive} ]] && continue
				error=1
			fi

			if [[ ! ${quiet} ]]; then
				einfo "Fixing shebang in ${f#${D%/}}."
			fi

			if [[ ! ${error} ]]; then
				# We either want to match ${from} followed by space
				# or at end-of-string.
				if [[ ${shebang} == *${from}" "* ]]; then
					sed -i -e "1s:${from} :${EPYTHON} :" "${f}" || die
				else
					sed -i -e "1s:${from}$:${EPYTHON}:" "${f}" || die
				fi
				any_fixed=1
			else
				eerror "The file has incompatible shebang:"
				eerror "  file: ${f#${D%/}}"
				eerror "  current shebang: ${shebang}"
				eerror "  requested impl: ${EPYTHON}"
				die "${FUNCNAME}: conversion of incompatible shebang requested"
			fi
		done < <(find -H "${path}" -type f -print0 || die)

		if [[ ! ${any_fixed} ]]; then
			local cmd=eerror
			[[ ${EAPI} == 5 ]] && cmd=eqawarn

			"${cmd}" "QA warning: ${FUNCNAME}, ${path#${D%/}} did not match any fixable files."
			if [[ ${any_correct} ]]; then
				"${cmd}" "All files have ${EPYTHON} shebang already."
			else
				"${cmd}" "There are no Python files in specified directory."
			fi

			[[ ${cmd} == eerror ]] && die "${FUNCNAME} did not match any fixable files (QA warning fatal in EAPI ${EAPI})"
		fi
	done
}

# @FUNCTION: _python_check_locale_sanity
# @USAGE: <locale>
# @RETURN: 0 if sane, 1 otherwise
# @INTERNAL
# @DESCRIPTION:
# Check whether the specified locale sanely maps between lowercase
# and uppercase ASCII characters.
_python_check_locale_sanity() {
	local -x LC_ALL=${1}
	local IFS=

	local lc=( {a..z} )
	local uc=( {A..Z} )
	local input="${lc[*]}${uc[*]}"

	local output=$(tr '[:lower:][:upper:]' '[:upper:][:lower:]' <<<"${input}")
	[[ ${output} == "${uc[*]}${lc[*]}" ]]
}

# @FUNCTION: python_export_utf8_locale
# @RETURN: 0 on success, 1 on failure.
# @DESCRIPTION:
# Attempts to export a usable UTF-8 locale in the LC_CTYPE variable. Does
# nothing if LC_ALL is defined, or if the current locale uses a UTF-8 charmap.
# This may be used to work around the quirky open() behavior of python3.
python_export_utf8_locale() {
	debug-print-function ${FUNCNAME} "${@}"

	# If the locale program isn't available, just return.
	type locale >/dev/null || return 0

	if [[ $(locale charmap) != UTF-8 ]]; then
		# Try English first, then everything else.
		local lang locales="C.UTF-8 en_US.UTF-8 en_GB.UTF-8 $(locale -a)"

		for lang in ${locales}; do
			if [[ $(LC_ALL=${lang} locale charmap 2>/dev/null) == UTF-8 ]]; then
				if _python_check_locale_sanity "${lang}"; then
					export LC_CTYPE=${lang}
					if [[ -n ${LC_ALL} ]]; then
						export LC_NUMERIC=${LC_ALL}
						export LC_TIME=${LC_ALL}
						export LC_COLLATE=${LC_ALL}
						export LC_MONETARY=${LC_ALL}
						export LC_MESSAGES=${LC_ALL}
						export LC_PAPER=${LC_ALL}
						export LC_NAME=${LC_ALL}
						export LC_ADDRESS=${LC_ALL}
						export LC_TELEPHONE=${LC_ALL}
						export LC_MEASUREMENT=${LC_ALL}
						export LC_IDENTIFICATION=${LC_ALL}
						export LC_ALL=
					fi
					return 0
				fi
			fi
		done

		ewarn "Could not find a UTF-8 locale. This may trigger build failures in"
		ewarn "some python packages. Please ensure that a UTF-8 locale is listed in"
		ewarn "/etc/locale.gen and run locale-gen."
		return 1
	fi

	return 0
}

# @FUNCTION: build_sphinx
# @USAGE: <directory>
# @DESCRIPTION:
# Build HTML documentation using dev-python/sphinx in the specified
# <directory>.  Takes care of disabling Intersphinx and appending
# to HTML_DOCS.
#
# If <directory> is relative to the current directory, care needs
# to be taken to run einstalldocs from the same directory
# (usually ${S}).
build_sphinx() {
	debug-print-function ${FUNCNAME} "${@}"
	[[ ${#} -eq 1 ]] || die "${FUNCNAME} takes 1 arg: <directory>"

	local dir=${1}

	sed -i -e 's:^intersphinx_mapping:disabled_&:' \
		"${dir}"/conf.py || die
	# not all packages include the Makefile in pypi tarball
	sphinx-build -b html -d "${dir}"/_build/doctrees "${dir}" \
		"${dir}"/_build/html || die

	HTML_DOCS+=( "${dir}/_build/html/." )
}

# -- python.eclass functions --

_python_check_dead_variables() {
	local v

	for v in PYTHON_DEPEND PYTHON_USE_WITH{,_OR,_OPT} {RESTRICT,SUPPORT}_PYTHON_ABIS
	do
		if [[ ${!v} ]]; then
			die "${v} is invalid for python-r1 suite, please take a look @ https://wiki.gentoo.org/wiki/Project:Python/Python.eclass_conversion#Ebuild_head"
		fi
	done

	for v in PYTHON_{CPPFLAGS,CFLAGS,CXXFLAGS,LDFLAGS}
	do
		if [[ ${!v} ]]; then
			die "${v} is invalid for python-r1 suite, please take a look @ https://wiki.gentoo.org/wiki/Project:Python/Python.eclass_conversion#PYTHON_CFLAGS"
		fi
	done

	for v in PYTHON_TESTS_RESTRICTED_ABIS PYTHON_EXPORT_PHASE_FUNCTIONS \
		PYTHON_VERSIONED_{SCRIPTS,EXECUTABLES} PYTHON_NONVERSIONED_EXECUTABLES
	do
		if [[ ${!v} ]]; then
			die "${v} is invalid for python-r1 suite"
		fi
	done

	for v in DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES DISTUTILS_SETUP_FILES \
		DISTUTILS_GLOBAL_OPTIONS DISTUTILS_SRC_TEST PYTHON_MODNAME
	do
		if [[ ${!v} ]]; then
			die "${v} is invalid for distutils-r1, please take a look @ https://wiki.gentoo.org/wiki/Project:Python/Python.eclass_conversion#${v}"
		fi
	done

	if [[ ${DISTUTILS_DISABLE_TEST_DEPENDENCY} ]]; then
		die "${v} is invalid for distutils-r1, please take a look @ https://wiki.gentoo.org/wiki/Project:Python/Python.eclass_conversion#DISTUTILS_SRC_TEST"
	fi

	# python.eclass::progress
	for v in PYTHON_BDEPEND PYTHON_MULTIPLE_ABIS PYTHON_ABI_TYPE \
		PYTHON_RESTRICTED_ABIS PYTHON_TESTS_FAILURES_TOLERANT_ABIS \
		PYTHON_CFFI_MODULES_GENERATION_COMMANDS
	do
		if [[ ${!v} ]]; then
			die "${v} is invalid for python-r1 suite"
		fi
	done
}

python_pkg_setup() {
	die "${FUNCNAME}() is invalid for python-r1 suite, please take a look @ https://wiki.gentoo.org/wiki/Project:Python/Python.eclass_conversion#pkg_setup"
}

python_convert_shebangs() {
	die "${FUNCNAME}() is invalid for python-r1 suite, please take a look @ https://wiki.gentoo.org/wiki/Project:Python/Python.eclass_conversion#python_convert_shebangs"
}

python_clean_py-compile_files() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_clean_installation_image() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_execute_function() {
	die "${FUNCNAME}() is invalid for python-r1 suite, please take a look @ https://wiki.gentoo.org/wiki/Project:Python/Python.eclass_conversion#python_execute_function"
}

python_generate_wrapper_scripts() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_merge_intermediate_installation_images() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_set_active_version() {
	die "${FUNCNAME}() is invalid for python-r1 suite, please take a look @ https://wiki.gentoo.org/wiki/Project:Python/Python.eclass_conversion#pkg_setup"
}

python_need_rebuild() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

PYTHON() {
	die "${FUNCNAME}() is invalid for python-r1 suite, please take a look @ https://wiki.gentoo.org/wiki/Project:Python/Python.eclass_conversion#.24.28PYTHON.29.2C_.24.7BEPYTHON.7D"
}

python_get_implementation() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_get_implementational_package() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_get_libdir() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_get_library() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_get_version() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_get_implementation_and_version() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_execute_nosetests() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_execute_py.test() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_execute_trial() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_enable_pyc() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_disable_pyc() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_mod_optimize() {
	die "${FUNCNAME}() is invalid for python-r1 suite, please take a look @ https://wiki.gentoo.org/wiki/Project:Python/Python.eclass_conversion#Python_byte-code_compilation"
}

python_mod_cleanup() {
	die "${FUNCNAME}() is invalid for python-r1 suite, please take a look @ https://wiki.gentoo.org/wiki/Project:Python/Python.eclass_conversion#Python_byte-code_compilation"
}

# python.eclass::progress

python_abi_depend() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_install_executables() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_get_extension_module_suffix() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_byte-compile_modules() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_clean_byte-compiled_modules() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

python_generate_cffi_modules() {
	die "${FUNCNAME}() is invalid for python-r1 suite"
}

_PYTHON_UTILS_R1=1
fi
