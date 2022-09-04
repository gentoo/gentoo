# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: python-utils-r1.eclass
# @MAINTAINER:
# Python team <python@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# Based on work of: Krzysztof Pawlik <nelchael@gentoo.org>
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: Utility functions for packages with Python parts.
# @DESCRIPTION:
# A utility eclass providing functions to query Python implementations,
# install Python modules and scripts.
#
# This eclass does not set any metadata variables nor export any phase
# functions. It can be inherited safely.
#
# For more information, please see the Python Guide:
# https://projects.gentoo.org/python/guide/

# NOTE: When dropping support for EAPIs here, we need to update
# metadata/install-qa-check.d/60python-pyc
# See bug #704286, bug #781878
case "${EAPI:-0}" in
	[0-5]) die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}" ;;
	[6-8]) ;;
	*)     die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}" ;;
esac

if [[ ${_PYTHON_ECLASS_INHERITED} ]]; then
	die 'python-r1 suite eclasses can not be used with python.eclass.'
fi

if [[ ! ${_PYTHON_UTILS_R1} ]]; then

[[ ${EAPI} == [67] ]] && inherit eapi8-dosym
[[ ${EAPI} == 6 ]] && inherit eqawarn
inherit multiprocessing toolchain-funcs

# @ECLASS_VARIABLE: _PYTHON_ALL_IMPLS
# @INTERNAL
# @DESCRIPTION:
# All supported Python implementations, most preferred last.
_PYTHON_ALL_IMPLS=(
	pypy3
	python3_{8..11}
)
readonly _PYTHON_ALL_IMPLS

# @ECLASS_VARIABLE: _PYTHON_HISTORICAL_IMPLS
# @INTERNAL
# @DESCRIPTION:
# All historical Python implementations that are no longer supported.
_PYTHON_HISTORICAL_IMPLS=(
	jython2_7
	pypy pypy1_{8,9} pypy2_0
	python2_{5..7}
	python3_{1..7}
)
readonly _PYTHON_HISTORICAL_IMPLS

# @ECLASS_VARIABLE: PYTHON_COMPAT_NO_STRICT
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
		case ${pattern} in
			-[23]|3.[89]|3.1[01])
				continue
				;;
		esac

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

	local obsolete=()
	if [[ ! ${PYTHON_COMPAT_NO_STRICT} ]]; then
		for i in "${PYTHON_COMPAT[@]}"; do
			# check for incorrect implementations
			# we're using pattern matching as an optimization
			# please keep them in sync with _PYTHON_ALL_IMPLS
			# and _PYTHON_HISTORICAL_IMPLS
			case ${i} in
				pypy3|python2_7|python3_[89]|python3_1[01])
					;;
				jython2_7|pypy|pypy1_[89]|pypy2_0|python2_[5-6]|python3_[1-7])
					obsolete+=( "${i}" )
					;;
				*)
					if has "${i}" "${_PYTHON_ALL_IMPLS[@]}" \
						"${_PYTHON_HISTORICAL_IMPLS[@]}"
					then
						die "Mis-synced patterns in _python_set_impls: missing ${i}"
					else
						die "Invalid implementation in PYTHON_COMPAT: ${i}"
					fi
			esac
		done
	fi

	if [[ -n ${obsolete[@]} && ${EBUILD_PHASE} == setup ]]; then
		# complain if people don't clean up old impls while touching
		# the ebuilds recently.  use the copyright year to infer last
		# modification
		# NB: this check doesn't have to work reliably
		if [[ $(head -n 1 "${EBUILD}" 2>/dev/null) == *2022* ]]; then
			eqawarn "Please clean PYTHON_COMPAT of obsolete implementations:"
			eqawarn "  ${obsolete[*]}"
		fi
	fi

	local supp=() unsupp=()

	for i in "${_PYTHON_ALL_IMPLS[@]}"; do
		if has "${i}" "${PYTHON_COMPAT[@]}"; then
			supp+=( "${i}" )
		else
			unsupp+=( "${i}" )
		fi
	done

	if [[ ! ${supp[@]} ]]; then
		# special-case python2_7 for python-any-r1
		if [[ ${_PYTHON_ALLOW_PY27} ]] && has python2_7 "${PYTHON_COMPAT[@]}"
		then
			supp+=( python2_7 )
		else
			die "No supported implementation in PYTHON_COMPAT."
		fi
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
# <impl> can be in PYTHON_COMPAT or EPYTHON form. The patterns
# can either be fnmatch-style or stdlib versions, e.g. "3.8", "3.9".
# In the latter case, pypy3 will match if there is at least one pypy3
# version matching the stdlib version.
_python_impl_matches() {
	[[ ${#} -ge 1 ]] || die "${FUNCNAME}: takes at least 1 parameter"
	[[ ${#} -eq 1 ]] && return 0

	local impl=${1/./_} pattern
	shift

	for pattern; do
		case ${pattern} in
			-2|python2*|pypy)
				if [[ ${EAPI} != [67] ]]; then
					eerror
					eerror "Python 2 is no longer supported in Gentoo, please remove Python 2"
					eerror "${FUNCNAME[1]} calls."
					die "Passing ${pattern} to ${FUNCNAME[1]} is banned in EAPI ${EAPI}"
				fi
				;;
			-3)
				# NB: "python3*" is fine, as "not pypy3"
				if [[ ${EAPI} != [67] ]]; then
					eerror
					eerror "Python 2 is no longer supported in Gentoo, please remove Python 2"
					eerror "${FUNCNAME[1]} calls."
					die "Passing ${pattern} to ${FUNCNAME[1]} is banned in EAPI ${EAPI}"
				fi
				return 0
				;;
			3.9)
				# the only unmasked pypy3 version is pypy3.9 atm
				[[ ${impl} == python${pattern/./_} || ${impl} == pypy3 ]] &&
					return 0
				;;
			3.8|3.1[01])
				[[ ${impl} == python${pattern/./_} ]] && return 0
				;;
			*)
				# unify value style to allow lax matching
				[[ ${impl} == ${pattern/./_} ]] && return 0
				;;
		esac
	done

	return 1
}

# @ECLASS_VARIABLE: PYTHON
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

# @ECLASS_VARIABLE: EPYTHON
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
				PYTHON_SITEDIR=$(
					"${PYTHON}" - <<-EOF || die
						import sysconfig
						print(sysconfig.get_path("purelib"))
					EOF
				)
				export PYTHON_SITEDIR
				debug-print "${FUNCNAME}: PYTHON_SITEDIR = ${PYTHON_SITEDIR}"
				;;
			PYTHON_INCLUDEDIR)
				[[ -n ${PYTHON} ]] || die "PYTHON needs to be set for ${var} to be exported, or requested before it"
				PYTHON_INCLUDEDIR=$(
					"${PYTHON}" - <<-EOF || die
						import sysconfig
						print(sysconfig.get_path("platinclude"))
					EOF
				)
				export PYTHON_INCLUDEDIR
				debug-print "${FUNCNAME}: PYTHON_INCLUDEDIR = ${PYTHON_INCLUDEDIR}"

				# Jython gives a non-existing directory
				if [[ ! -d ${PYTHON_INCLUDEDIR} ]]; then
					die "${impl} does not install any header files!"
				fi
				;;
			PYTHON_LIBPATH)
				[[ -n ${PYTHON} ]] || die "PYTHON needs to be set for ${var} to be exported, or requested before it"
				PYTHON_LIBPATH=$(
					"${PYTHON}" - <<-EOF || die
						import os.path, sysconfig
						print(
							os.path.join(
								sysconfig.get_config_var("LIBDIR"),
								sysconfig.get_config_var("LDLIBRARY"))
							if sysconfig.get_config_var("LDLIBRARY")
							else "")
					EOF
				)
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
						flags=$(
							"${PYTHON}" - <<-EOF || die
								import sysconfig
								print(sysconfig.get_config_var("ABIFLAGS")
									or "")
							EOF
						)
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
						PYTHON_PKG_DEP='>=dev-lang/python-2.7.10_p15:2.7';;
					python3.8)
						PYTHON_PKG_DEP=">=dev-lang/python-3.8.13:3.8";;
					python3.9)
						PYTHON_PKG_DEP=">=dev-lang/python-3.9.12:3.9";;
					python3.10)
						PYTHON_PKG_DEP=">=dev-lang/python-3.10.4:3.10";;
					python3.11)
						PYTHON_PKG_DEP=">=dev-lang/python-3.11.0_beta4:3.11";;
					python*)
						PYTHON_PKG_DEP="dev-lang/python:${impl#python}";;
					pypy)
						PYTHON_PKG_DEP='>=dev-python/pypy-7.3.9:0=';;
					pypy3)
						PYTHON_PKG_DEP='>=dev-python/pypy3-7.3.9_p1:0=';;
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

# @FUNCTION: python_optimize
# @USAGE: [<directory>...]
# @DESCRIPTION:
# Compile and optimize Python modules in specified directories (absolute
# paths). If no directories are provided, the default system paths
# are used (prepended with ${D}).
python_optimize() {
	debug-print-function ${FUNCNAME} "${@}"

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
		done < <(
			"${PYTHON}" - <<-EOF || die
				import sys
				print("".join(x + "\0" for x in sys.path))
			EOF
		)

		debug-print "${FUNCNAME}: using sys.path: ${*/%/;}"
	fi

	local jobs=$(makeopts_jobs)
	local d
	for d; do
		# make sure to get a nice path without //
		local instpath=${d#${D%/}}
		instpath=/${instpath##/}

		einfo "Optimize Python modules for ${instpath}"
		case "${EPYTHON}" in
			python2.7|python3.[34])
				"${PYTHON}" -m compileall -q -f -d "${instpath}" "${d}"
				"${PYTHON}" -OO -m compileall -q -f -d "${instpath}" "${d}"
				;;
			python3.[5678]|pypy3)
				# both levels of optimization are separate since 3.5
				"${PYTHON}" -m compileall -j "${jobs}" -q -f -d "${instpath}" "${d}"
				"${PYTHON}" -O -m compileall -j "${jobs}" -q -f -d "${instpath}" "${d}"
				"${PYTHON}" -OO -m compileall -j "${jobs}" -q -f -d "${instpath}" "${d}"
				;;
			python*)
				"${PYTHON}" -m compileall -j "${jobs}" -o 0 -o 1 -o 2 --hardlink-dupes -q -f -d "${instpath}" "${d}"
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

	_PYTHON_SCRIPTROOT=${1}
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

	[[ ${EBUILD_PHASE} != install ]] &&
		die "${FUNCNAME} can only be used in src_install"

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

	[[ ${EBUILD_PHASE} != install ]] &&
		die "${FUNCNAME} can only be used in src_install"
	[[ ${EPYTHON} ]] || die 'No Python implementation set (EPYTHON is null).'
	[[ ${#} -eq 2 ]] || die "Usage: ${FUNCNAME} <path> <new-name>"

	local wrapd=${_PYTHON_SCRIPTROOT:-/usr/bin}

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
	local dosym=dosym
	[[ ${EAPI} == [67] ]] && dosym=dosym8
	"${dosym}" -r /usr/lib/python-exec/python-exec2 "${wrapd}/${newfn}"

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

	[[ ${EBUILD_PHASE} != install ]] &&
		die "${FUNCNAME} can only be used in src_install"

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

	[[ ${EBUILD_PHASE} != install ]] &&
		die "${FUNCNAME} can only be used in src_install"

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
# by each python_domodule invocation. Therefore, python_moduleinto
# can be safely called before establishing the Python interpreter and/or
# a single call can be used to set the path correctly for multiple
# implementations, as can be seen in the following example.
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

	_PYTHON_MODULEROOT=${1}
}

# @FUNCTION: python_domodule
# @USAGE: <files>...
# @DESCRIPTION:
# Install the given modules (or packages) into the current Python module
# installation directory. The list can mention both modules (files)
# and packages (directories). All listed files will be installed
# for all enabled implementations, and compiled afterwards.
#
# The files are installed into ${D} when run in src_install() phase.
# Otherwise, they are installed into ${BUILD_DIR}/install location
# that is suitable for picking up by distutils-r1 in PEP517 mode.
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
	if [[ ${_PYTHON_MODULEROOT} == /* ]]; then
		# absolute path
		d=${_PYTHON_MODULEROOT}
	else
		# relative to site-packages
		local sitedir=$(python_get_sitedir)
		d=${sitedir#${EPREFIX}}/${_PYTHON_MODULEROOT//.//}
	fi

	if [[ ${EBUILD_PHASE} == install ]]; then
		(
			insopts -m 0644
			insinto "${d}"
			doins -r "${@}" || return ${?}
		)
		python_optimize "${ED%/}/${d}"
	elif [[ -n ${BUILD_DIR} ]]; then
		local dest=${BUILD_DIR}/install${EPREFIX}/${d}
		mkdir -p "${dest}" || die
		cp -pR "${@}" "${dest}/" || die
		(
			cd "${dest}" &&
			chmod -R a+rX "${@##*/}"
		) || die
	else
		die "${FUNCNAME} can only be used in src_install or with BUILD_DIR set"
	fi
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

	[[ ${EBUILD_PHASE} != install ]] &&
		die "${FUNCNAME} can only be used in src_install"
	[[ ${EPYTHON} ]] || die 'No Python implementation set (EPYTHON is null).'

	local includedir=$(python_get_includedir)
	local d=${includedir#${EPREFIX}}

	(
		insopts -m 0644
		insinto "${d}"
		doins -r "${@}" || return ${?}
	)
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
		mkdir -p "${workdir}"/{bin,pkgconfig} || die

		# Clean up, in case we were supposed to do a cheap update.
		rm -f "${workdir}"/bin/python{,2,3}{,-config} || die
		rm -f "${workdir}"/bin/2to3 || die
		rm -f "${workdir}"/pkgconfig/python{2,3}{,-embed}.pc || die

		local EPYTHON PYTHON
		_python_export "${impl}" EPYTHON PYTHON

		local pyver pyother
		if [[ ${EPYTHON} != python2* ]]; then
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

# @FUNCTION: python_fix_shebang
# @USAGE: [-f|--force] [-q|--quiet] <path>...
# @DESCRIPTION:
# Replace the shebang in Python scripts with the full path
# to the current Python implementation (PYTHON, including EPREFIX).
# If a directory is passed, works recursively on all Python scripts
# found inside the directory tree.
#
# Only files having a Python shebang (a path to any known Python
# interpreter, optionally preceded by env(1) invocation) will
# be processed.  Files with any other shebang will either be skipped
# silently when a directory was passed, or an error will be reported
# for any files without Python shebangs specified explicitly.
#
# Shebangs that are compatible with the current Python version will be
# mangled unconditionally.  Incompatible shebangs will cause a fatal
# error, unless --force is specified.
#
# --force causes the function to replace shebangs with incompatible
# Python version (but not non-Python shebangs).  --quiet causes
# the function not to list modified files verbosely.
python_fix_shebang() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${EPYTHON} ]] || die "${FUNCNAME}: EPYTHON unset (pkg_setup not called?)"
	local PYTHON
	_python_export "${EPYTHON}" PYTHON

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
		local any_fixed is_recursive

		[[ -d ${path} ]] && is_recursive=1

		while IFS= read -r -d '' f; do
			local shebang i
			local error= match=

			# note: we can't ||die here since read will fail if file
			# has no newline characters
			IFS= read -r shebang <"${f}"

			# First, check if it's shebang at all...
			if [[ ${shebang} == '#!'* ]]; then
				local split_shebang=()
				read -r -a split_shebang <<<${shebang#"#!"} || die

				local in_path=${split_shebang[0]}
				local from='^#! *[^ ]*'
				# if the first component is env(1), skip it
				if [[ ${in_path} == */env ]]; then
					in_path=${split_shebang[1]}
					from+=' *[^ ]*'
				fi

				case ${in_path##*/} in
					"${EPYTHON}")
						match=1
						;;
					python|python[23])
						match=1
						[[ ${in_path##*/} == python2 ]] && error=1
						;;
					python[23].[0-9]|python3.[1-9][0-9]|pypy|pypy3|jython[23].[0-9])
						# Explicit mismatch.
						match=1
						error=1
						;;
				esac
			fi

			# disregard mismatches in force mode
			[[ ${force} ]] && error=

			if [[ ! ${match} ]]; then
				# Non-Python shebang. Allowed in recursive mode,
				# disallowed when specifying file explicitly.
				[[ ${is_recursive} ]] && continue
				error=1
			fi

			if [[ ! ${quiet} ]]; then
				einfo "Fixing shebang in ${f#${D%/}}."
			fi

			if [[ ! ${error} ]]; then
				debug-print "${FUNCNAME}: in file ${f#${D%/}}"
				debug-print "${FUNCNAME}: rewriting shebang: ${shebang}"
				sed -i -e "1s@${from}@#!${PYTHON}@" "${f}" || die
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
			eerror "QA error: ${FUNCNAME}, ${path#${D%/}} did not match any fixable files."
			eerror "There are no Python files in specified directory."
			die "${FUNCNAME} did not match any fixable files"
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
	type locale &>/dev/null || return 0

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
	# 1. not all packages include the Makefile in pypi tarball,
	# so we call sphinx-build directly
	# 2. if autodoc is used, we need to call sphinx via EPYTHON,
	# to ensure that PEP 517 venv is respected
	# 3. if autodoc is not used, then sphinx might not be installed
	# for the current impl, so we need a fallback to sphinx-build
	local command=( "${EPYTHON}" -m sphinx.cmd.build )
	if ! "${EPYTHON}" -c "import sphinx.cmd.build" 2>/dev/null; then
		command=( sphinx-build )
	fi
	command+=(
		-b html
		-d "${dir}"/_build/doctrees
		"${dir}"
		"${dir}"/_build/html
	)
	echo "${command[@]}" >&2
	"${command[@]}" || die

	HTML_DOCS+=( "${dir}/_build/html/." )
}

# @FUNCTION: _python_check_EPYTHON
# @INTERNAL
# @DESCRIPTION:
# Check if EPYTHON is set, die if not.
_python_check_EPYTHON() {
	if [[ -z ${EPYTHON} ]]; then
		die "EPYTHON unset, invalid call context"
	fi
}

# @VARIABLE: EPYTEST_DESELECT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Specifies an array of tests to be deselected via pytest's --deselect
# parameter, when calling epytest.  The list can include file paths,
# specific test functions or parametrized test invocations.
#
# Note that the listed files will still be subject to collection,
# i.e. modules imported in global scope will need to be available.
# If this is undesirable, EPYTEST_IGNORE can be used instead.

# @VARIABLE: EPYTEST_IGNORE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Specifies an array of paths to be ignored via pytest's --ignore
# parameter, when calling epytest.  The listed files will be entirely
# skipped from test collection.

# @FUNCTION: epytest
# @USAGE: [<args>...]
# @DESCRIPTION:
# Run pytest, passing the standard set of pytest options, then
# --deselect and --ignore options based on EPYTEST_DESELECT
# and EPYTEST_IGNORE, then user-specified options.
#
# This command dies on failure and respects nonfatal.
epytest() {
	debug-print-function ${FUNCNAME} "${@}"

	_python_check_EPYTHON

	local color
	case ${NOCOLOR} in
		true|yes)
			color=no
			;;
		*)
			color=yes
			;;
	esac

	local args=(
		# verbose progress reporting and tracebacks
		-vv
		# list all non-passed tests in the summary for convenience
		# (includes failures, skips, xfails...)
		-ra
		# print local variables in tracebacks, useful for debugging
		-l
		# override filterwarnings=error, we do not really want -Werror
		# for end users, as it tends to fail on new warnings from deps
		-Wdefault
		# override color output
		"--color=${color}"
		# count is more precise when we're dealing with a large number
		# of tests
		-o console_output_style=count
		# disable the undesirable-dependency plugins by default to
		# trigger missing argument strips.  strip options that require
		# them from config files.  enable them explicitly via "-p ..."
		# if you *really* need them.
		-p no:cov
		-p no:flake8
		-p no:flakes
		-p no:pylint
		# sterilize pytest-markdown as it runs code snippets from all
		# *.md files found without any warning
		-p no:markdown
		# pytest-sugar undoes everything that's good about pytest output
		# and makes it hard to read logs
		-p no:sugar
		# pytest-xvfb automatically spawns Xvfb for every test suite,
		# effectively forcing it even when we'd prefer the tests
		# not to have DISPLAY at all, causing crashes sometimes
		# and causing us to miss missing virtualx usage
		-p no:xvfb
	)
	local x
	for x in "${EPYTEST_DESELECT[@]}"; do
		args+=( --deselect "${x}" )
	done
	for x in "${EPYTEST_IGNORE[@]}"; do
		args+=( --ignore "${x}" )
	done
	set -- "${EPYTHON}" -m pytest "${args[@]}" "${@}"

	echo "${@}" >&2
	"${@}" || die -n "pytest failed with ${EPYTHON}"
	local ret=${?}

	# remove common temporary directories left over by pytest plugins
	rm -rf .hypothesis .pytest_cache || die
	# pytest plugins create additional .pyc files while testing
	# see e.g. https://bugs.gentoo.org/847235
	if [[ -n ${BUILD_DIR} && -d ${BUILD_DIR} ]]; then
		find "${BUILD_DIR}" -name '*-pytest-*.pyc' -delete || die
	fi

	return ${ret}
}

# @FUNCTION: eunittest
# @USAGE: [<args>...]
# @DESCRIPTION:
# Run unit tests using dev-python/unittest-or-fail, passing the standard
# set of options, followed by user-specified options.
#
# This command dies on failure and respects nonfatal.
eunittest() {
	debug-print-function ${FUNCNAME} "${@}"

	_python_check_EPYTHON

	set -- "${EPYTHON}" -m unittest_or_fail discover -v "${@}"

	echo "${@}" >&2
	"${@}" || die -n "Tests failed with ${EPYTHON}"
	return ${?}
}

# @FUNCTION: _python_run_check_deps
# @INTERNAL
# @USAGE: <impl>
# @DESCRIPTION:
# Verify whether <impl> is an acceptable choice to run any-r1 style
# code.  Checks whether the interpreter is installed, runs
# python_check_deps() if declared.
_python_run_check_deps() {
	debug-print-function ${FUNCNAME} "${@}"

	local impl=${1}
	local hasv_args=( -b )
	[[ ${EAPI} == 6 ]] && hasv_args=( --host-root )

	einfo "Checking whether ${impl} is suitable ..."

	local PYTHON_PKG_DEP
	_python_export "${impl}" PYTHON_PKG_DEP
	ebegin "  ${PYTHON_PKG_DEP}"
	has_version "${hasv_args[@]}" "${PYTHON_PKG_DEP}"
	eend ${?} || return 1
	declare -f python_check_deps >/dev/null || return 0

	local PYTHON_USEDEP="python_targets_${impl}(-)"
	local PYTHON_SINGLE_USEDEP="python_single_target_${impl}(-)"
	ebegin "  python_check_deps"
	python_check_deps
	eend ${?}
}

# @FUNCTION: python_has_version
# @USAGE: [-b|-d|-r] <atom>...
# @DESCRIPTION:
# A convenience wrapper for has_version() with verbose output and better
# defaults for use in python_check_deps().
#
# The wrapper accepts EAPI 7+-style -b/-d/-r options to indicate
# the root to perform the lookup on.  Unlike has_version, the default
# is -b.  In EAPI 6, -b and -d are translated to --host-root
# for compatibility.
#
# The wrapper accepts multiple package specifications.  For the check
# to succeed, *all* specified atoms must match.
python_has_version() {
	debug-print-function ${FUNCNAME} "${@}"

	local root_arg=( -b )
	case ${1} in
		-b|-d|-r)
			root_arg=( "${1}" )
			shift
			;;
	esac

	if [[ ${EAPI} == 6 ]]; then
		if [[ ${root_arg} == -r ]]; then
			root_arg=()
		else
			root_arg=( --host-root )
		fi
	fi

	local pkg
	for pkg; do
		ebegin "    ${pkg}"
		has_version "${root_arg[@]}" "${pkg}"
		eend ${?} || return
	done

	return 0
}

_PYTHON_UTILS_R1=1
fi
