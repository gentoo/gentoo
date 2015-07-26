# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/python-utils-r1.eclass,v 1.84 2015/07/25 10:07:36 mgorny Exp $

# @ECLASS: python-utils-r1
# @MAINTAINER:
# Python team <python@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# Based on work of: Krzysztof Pawlik <nelchael@gentoo.org>
# @BLURB: Utility functions for packages with Python parts.
# @DESCRIPTION:
# A utility eclass providing functions to query Python implementations,
# install Python modules and scripts.
#
# This eclass does not set any metadata variables nor export any phase
# functions. It can be inherited safely.
#
# For more information, please see the wiki:
# https://wiki.gentoo.org/wiki/Project:Python/python-utils-r1

case "${EAPI:-0}" in
	0|1|2|3|4|5)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

if [[ ${_PYTHON_ECLASS_INHERITED} ]]; then
	die 'python-r1 suite eclasses can not be used with python.eclass.'
fi

if [[ ! ${_PYTHON_UTILS_R1} ]]; then

inherit eutils multilib toolchain-funcs

# @ECLASS-VARIABLE: _PYTHON_ALL_IMPLS
# @INTERNAL
# @DESCRIPTION:
# All supported Python implementations, most preferred last.
_PYTHON_ALL_IMPLS=(
	jython2_5 jython2_7
	pypy pypy3
	python3_3 python3_4
	python2_7
)

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
		python2_7|python3_[34]|jython2_[57])
			return 0
			;;
		pypy1_[89]|pypy2_0|python2_[56]|python3_[12])
			return 1
			;;
		pypy|pypy3)
			if [[ ${EAPI:-0} == [01234] ]]; then
				die "PyPy is supported in EAPI 5 and newer only."
			fi
			;;
		*)
			die "Invalid implementation in PYTHON_COMPAT: ${impl}"
	esac
}

# @ECLASS-VARIABLE: PYTHON
# @DEFAULT_UNSET
# @DESCRIPTION:
# The absolute path to the current Python interpreter.
#
# This variable is set automatically in the following contexts:
#
# python-r1: Set in functions called by python_foreach_impl() or after
# calling python_export_best().
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
# calling python_export_best().
#
# python-single-r1: Set after calling python-single-r1_pkg_setup().
#
# distutils-r1: Set within any of the python sub-phase functions.
#
# Example value:
# @CODE
# python2.7
# @CODE

# @ECLASS-VARIABLE: PYTHON_SITEDIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# The path to Python site-packages directory.
#
# Set and exported on request using python_export().
#
# Example value:
# @CODE
# /usr/lib64/python2.7/site-packages
# @CODE

# @ECLASS-VARIABLE: PYTHON_INCLUDEDIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# The path to Python include directory.
#
# Set and exported on request using python_export().
#
# Example value:
# @CODE
# /usr/include/python2.7
# @CODE

# @ECLASS-VARIABLE: PYTHON_LIBPATH
# @DEFAULT_UNSET
# @DESCRIPTION:
# The path to Python library.
#
# Set and exported on request using python_export().
# Valid only for CPython.
#
# Example value:
# @CODE
# /usr/lib64/libpython2.7.so
# @CODE

# @ECLASS-VARIABLE: PYTHON_CFLAGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Proper C compiler flags for building against Python. Obtained from
# pkg-config or python-config.
#
# Set and exported on request using python_export().
# Valid only for CPython. Requires a proper build-time dependency
# on the Python implementation and on pkg-config.
#
# Example value:
# @CODE
# -I/usr/include/python2.7
# @CODE

# @ECLASS-VARIABLE: PYTHON_LIBS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Proper C compiler flags for linking against Python. Obtained from
# pkg-config or python-config.
#
# Set and exported on request using python_export().
# Valid only for CPython. Requires a proper build-time dependency
# on the Python implementation and on pkg-config.
#
# Example value:
# @CODE
# -lpython2.7
# @CODE

# @ECLASS-VARIABLE: PYTHON_PKG_DEP
# @DEFAULT_UNSET
# @DESCRIPTION:
# The complete dependency on a particular Python package as a string.
#
# Set and exported on request using python_export().
#
# Example value:
# @CODE
# dev-lang/python:2.7[xml]
# @CODE

# @ECLASS-VARIABLE: PYTHON_SCRIPTDIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# The location where Python scripts must be installed for current impl.
#
# Set and exported on request using python_export().
#
# Example value:
# @CODE
# /usr/lib/python-exec/python2.7
# @CODE

# @FUNCTION: python_export
# @USAGE: [<impl>] <variables>...
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
python_export() {
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
				die "python_export called without a python implementation and EPYTHON is unset"
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
				local dir
				case "${impl}" in
					python*|pypy|pypy3)
						dir=/usr/$(get_libdir)/${impl}
						;;
					jython*)
						dir=/usr/share/${impl/n/n-}/Lib
						;;
				esac

				export PYTHON_SITEDIR=${EPREFIX}${dir}/site-packages
				debug-print "${FUNCNAME}: PYTHON_SITEDIR = ${PYTHON_SITEDIR}"
				;;
			PYTHON_INCLUDEDIR)
				local dir
				case "${impl}" in
					python*)
						dir=/usr/include/${impl}
						;;
					pypy|pypy3)
						dir=/usr/$(get_libdir)/${impl}/include
						;;
					*)
						die "${impl} lacks header files"
						;;
				esac

				export PYTHON_INCLUDEDIR=${EPREFIX}${dir}
				debug-print "${FUNCNAME}: PYTHON_INCLUDEDIR = ${PYTHON_INCLUDEDIR}"
				;;
			PYTHON_LIBPATH)
				local libname
				case "${impl}" in
					python*)
						libname=lib${impl}
						;;
					*)
						die "${impl} lacks a dynamic library"
						;;
				esac

				local path=${EPREFIX}/usr/$(get_libdir)

				export PYTHON_LIBPATH=${path}/${libname}$(get_libname)
				debug-print "${FUNCNAME}: PYTHON_LIBPATH = ${PYTHON_LIBPATH}"
				;;
			PYTHON_CFLAGS)
				local val

				case "${impl}" in
					python*)
						# python-2.7, python-3.2, etc.
						val=$($(tc-getPKG_CONFIG) --cflags ${impl/n/n-})
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
					python*)
						# python-2.7, python-3.2, etc.
						val=$($(tc-getPKG_CONFIG) --libs ${impl/n/n-})
						;;
					*)
						die "${impl}: obtaining ${var} not supported"
						;;
				esac

				export PYTHON_LIBS=${val}
				debug-print "${FUNCNAME}: PYTHON_LIBS = ${PYTHON_LIBS}"
				;;
			PYTHON_PKG_DEP)
				local d
				case ${impl} in
					python2.7)
						PYTHON_PKG_DEP='>=dev-lang/python-2.7.5-r2:2.7';;
					python3.3)
						PYTHON_PKG_DEP='>=dev-lang/python-3.3.2-r2:3.3';;
					python*)
						PYTHON_PKG_DEP="dev-lang/python:${impl#python}";;
					pypy)
						PYTHON_PKG_DEP='virtual/pypy:0=';;
					pypy3)
						PYTHON_PKG_DEP='virtual/pypy3:0=';;
					jython2.5)
						PYTHON_PKG_DEP='>=dev-java/jython-2.5.3-r2:2.5';;
					jython2.7)
						PYTHON_PKG_DEP='dev-java/jython:2.7';;
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
				die "python_export: unknown variable ${var}"
		esac
	done
}

# @FUNCTION: python_get_sitedir
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the 'site-packages' path for the given
# implementation. If no implementation is provided, ${EPYTHON} will
# be used.
#
# If you just need to have PYTHON_SITEDIR set (and exported), then it is
# better to use python_export() directly instead.
python_get_sitedir() {
	debug-print-function ${FUNCNAME} "${@}"

	python_export "${@}" PYTHON_SITEDIR
	echo "${PYTHON_SITEDIR}"
}

# @FUNCTION: python_get_includedir
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the include path for the given implementation. If no
# implementation is provided, ${EPYTHON} will be used.
#
# If you just need to have PYTHON_INCLUDEDIR set (and exported), then it
# is better to use python_export() directly instead.
python_get_includedir() {
	debug-print-function ${FUNCNAME} "${@}"

	python_export "${@}" PYTHON_INCLUDEDIR
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

	python_export "${@}" PYTHON_LIBPATH
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

	python_export "${@}" PYTHON_CFLAGS
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

	python_export "${@}" PYTHON_LIBS
	echo "${PYTHON_LIBS}"
}

# @FUNCTION: python_get_scriptdir
# @USAGE: [<impl>]
# @DESCRIPTION:
# Obtain and print the script install path for the given
# implementation. If no implementation is provided, ${EPYTHON} will
# be used.
python_get_scriptdir() {
	debug-print-function ${FUNCNAME} "${@}"

	python_export "${@}" PYTHON_SCRIPTDIR
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
	[[ ${PYTHON} ]] || python_export PYTHON

	# Note: python2.6 can't handle passing files to compileall...
	# TODO: we do not support 2.6 any longer

	# default to sys.path
	if [[ ${#} -eq 0 ]]; then
		local f
		while IFS= read -r -d '' f; do
			# 1) accept only absolute paths
			#    (i.e. skip '', '.' or anything like that)
			# 2) skip paths which do not exist
			#    (python2.6 complains about them verbosely)

			if [[ ${f} == /* && -d ${D}${f} ]]; then
				set -- "${D}${f}" "${@}"
			fi
		done < <("${PYTHON}" -c 'import sys; print("\0".join(sys.path))')

		debug-print "${FUNCNAME}: using sys.path: ${*/%/;}"
	fi

	local d
	for d; do
		# make sure to get a nice path without //
		local instpath=${d#${D}}
		instpath=/${instpath##/}

		case "${EPYTHON}" in
			python*)
				"${PYTHON}" -m compileall -q -f -d "${instpath}" "${d}"
				"${PYTHON}" -OO -m compileall -q -f -d "${instpath}" "${d}"
				;;
			*)
				"${PYTHON}" -m compileall -q -f -d "${instpath}" "${d}"
				;;
		esac
	done
}

# @ECLASS-VARIABLE: python_scriptroot
# @DEFAULT_UNSET
# @DESCRIPTION:
# The current script destination for python_doscript(). The path
# is relative to the installation root (${ED}).
#
# When unset, ${DESTTREE}/bin (/usr/bin by default) will be used.
#
# Can be set indirectly through the python_scriptinto() function.
#
# Example:
# @CODE
# src_install() {
#   local python_scriptroot=${GAMES_BINDIR}
#   python_foreach_impl python_doscript foo
# }
# @CODE

# @FUNCTION: python_scriptinto
# @USAGE: <new-path>
# @DESCRIPTION:
# Set the current scriptroot. The new value will be stored
# in the 'python_scriptroot' environment variable. The new value need
# be relative to the installation root (${ED}).
#
# Alternatively, you can set the variable directly.
python_scriptinto() {
	debug-print-function ${FUNCNAME} "${@}"

	python_scriptroot=${1}
}

# @FUNCTION: python_doexe
# @USAGE: <files>...
# @DESCRIPTION:
# Install the given executables into current python_scriptroot,
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
# Install the given executable into current python_scriptroot,
# for the current Python implementation (${EPYTHON}).
#
# The executable will be wrapped properly for the Python implementation,
# though no shebang mangling will be performed. It will be renamed
# to <new-name>.
python_newexe() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${EPYTHON} ]] || die 'No Python implementation set (EPYTHON is null).'
	[[ ${#} -eq 2 ]] || die "Usage: ${FUNCNAME} <path> <new-name>"

	local wrapd=${python_scriptroot:-${DESTTREE}/bin}

	local f=${1}
	local newfn=${2}

	local PYTHON_SCRIPTDIR d
	python_export PYTHON_SCRIPTDIR
	d=${PYTHON_SCRIPTDIR#${EPREFIX}}

	(
		dodir "${wrapd}"
		exeinto "${d}"
		newexe "${f}" "${newfn}" || die
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
# Install the given scripts into current python_scriptroot,
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
# Install the given script into current python_scriptroot
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

# @ECLASS-VARIABLE: python_moduleroot
# @DEFAULT_UNSET
# @DESCRIPTION:
# The current module root for python_domodule(). The path can be either
# an absolute system path (it must start with a slash, and ${ED} will be
# prepended to it) or relative to the implementation's site-packages directory
# (then it must start with a non-slash character).
#
# When unset, the modules will be installed in the site-packages root.
#
# Can be set indirectly through the python_moduleinto() function.
#
# Example:
# @CODE
# src_install() {
#   local python_moduleroot=bar
#   # installs ${PYTHON_SITEDIR}/bar/baz.py
#   python_foreach_impl python_domodule baz.py
# }
# @CODE

# @FUNCTION: python_moduleinto
# @USAGE: <new-path>
# @DESCRIPTION:
# Set the current module root. The new value will be stored
# in the 'python_moduleroot' environment variable. The new value need
# be relative to the site-packages root.
#
# Alternatively, you can set the variable directly.
python_moduleinto() {
	debug-print-function ${FUNCNAME} "${@}"

	python_moduleroot=${1}
}

# @FUNCTION: python_domodule
# @USAGE: <files>...
# @DESCRIPTION:
# Install the given modules (or packages) into the current
# python_moduleroot. The list can mention both modules (files)
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
		local PYTHON_SITEDIR=${PYTHON_SITEDIR}
		[[ ${PYTHON_SITEDIR} ]] || python_export PYTHON_SITEDIR

		d=${PYTHON_SITEDIR#${EPREFIX}}/${python_moduleroot}
	fi

	local INSDESTTREE

	insinto "${d}"
	doins -r "${@}" || die

	python_optimize "${ED}/${d}"
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

	local d PYTHON_INCLUDEDIR=${PYTHON_INCLUDEDIR}
	[[ ${PYTHON_INCLUDEDIR} ]] || python_export PYTHON_INCLUDEDIR

	d=${PYTHON_INCLUDEDIR#${EPREFIX}}

	local INSDESTTREE

	insinto "${d}"
	doins -r "${@}" || die
}

# @FUNCTION: python_wrapper_setup
# @USAGE: [<path> [<impl>]]
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
python_wrapper_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	local workdir=${1:-${T}/${EPYTHON}}
	local impl=${2:-${EPYTHON}}

	[[ ${workdir} ]] || die "${FUNCNAME}: no workdir specified."
	[[ ${impl} ]] || die "${FUNCNAME}: no impl nor EPYTHON specified."

	if [[ ! -x ${workdir}/bin/python ]]; then
		_python_check_dead_variables

		mkdir -p "${workdir}"/{bin,pkgconfig} || die

		# Clean up, in case we were supposed to do a cheap update.
		rm -f "${workdir}"/bin/python{,2,3,-config} || die
		rm -f "${workdir}"/bin/2to3 || die
		rm -f "${workdir}"/pkgconfig/python{,2,3}.pc || die

		local EPYTHON PYTHON
		python_export "${impl}" EPYTHON PYTHON

		local pyver
		if python_is_python3; then
			pyver=3
		else
			pyver=2
		fi

		# Python interpreter
		ln -s "${PYTHON}" "${workdir}"/bin/python || die
		ln -s python "${workdir}"/bin/python${pyver} || die

		local nonsupp=()

		# CPython-specific
		if [[ ${EPYTHON} == python* ]]; then
			ln -s "${PYTHON}-config" "${workdir}"/bin/python-config || die

			# Python 2.6+.
			ln -s "${PYTHON/python/2to3-}" "${workdir}"/bin/2to3 || die

			# Python 2.7+.
			ln -s "${EPREFIX}"/usr/$(get_libdir)/pkgconfig/${EPYTHON/n/n-}.pc \
				"${workdir}"/pkgconfig/python.pc || die
			ln -s python.pc "${workdir}"/pkgconfig/python${pyver}.pc || die
		else
			nonsupp+=( 2to3 python-config )
		fi

		local x
		for x in "${nonsupp[@]}"; do
			cat >"${workdir}"/bin/${x} <<__EOF__
#!/bin/sh
echo "${x} is not supported by ${EPYTHON}" >&2
exit 1
__EOF__
			chmod +x "${workdir}"/bin/${x} || die
		done

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
	fi
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

	# for has_version
	local -x ROOT=/
	case "${impl}" in
		pypy|pypy3)
			local append=
			if [[ ${PYTHON_REQ_USE} ]]; then
				append=[${PYTHON_REQ_USE}]
			fi

			# be happy with just the interpeter, no need for the virtual
			has_version "dev-python/${impl}${append}" \
				|| has_version "dev-python/${impl}-bin${append}"
			;;
		*)
			local PYTHON_PKG_DEP
			python_export "${impl}" PYTHON_PKG_DEP
			has_version "${PYTHON_PKG_DEP}"
			;;
	esac
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

			IFS= read -r shebang <${f}

			# First, check if it's shebang at all...
			if [[ ${shebang} == '#!'* ]]; then
				local split_shebang=()
				read -r -a split_shebang <<<${shebang}

				# Match left-to-right in a loop, to avoid matching random
				# repetitions like 'python2.7 python2'.
				for i in "${split_shebang[@]}"; do
					case "${i}" in
						*"${EPYTHON}")
							debug-print "${FUNCNAME}: in file ${f#${D}}"
							debug-print "${FUNCNAME}: shebang matches EPYTHON: ${shebang}"

							# Nothing to do, move along.
							any_correct=1
							from=${EPYTHON}
							break
							;;
						*python|*python[23])
							debug-print "${FUNCNAME}: in file ${f#${D}}"
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
				einfo "Fixing shebang in ${f#${D}}."
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
				eerror "  file: ${f#${D}}"
				eerror "  current shebang: ${shebang}"
				eerror "  requested impl: ${EPYTHON}"
				die "${FUNCNAME}: conversion of incompatible shebang requested"
			fi
		done < <(find "${path}" -type f -print0)

		if [[ ! ${any_fixed} ]]; then
			eqawarn "QA warning: ${FUNCNAME}, ${path#${D}} did not match any fixable files."
			if [[ ${any_correct} ]]; then
				eqawarn "All files have ${EPYTHON} shebang already."
			else
				eqawarn "There are no Python files in specified directory."
			fi
		fi
	done
}

# @FUNCTION: python_export_utf8_locale
# @RETURN: 0 on success, 1 on failure.
# @DESCRIPTION:
# Attempts to export a usable UTF-8 locale in the LC_CTYPE variable. Does
# nothing if LC_ALL is defined, or if the current locale uses a UTF-8 charmap.
# This may be used to work around the quirky open() behavior of python3.
python_export_utf8_locale() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ $(locale charmap) != UTF-8 ]]; then
		if [[ -n ${LC_ALL} ]]; then
			ewarn "LC_ALL is set to a locale with a charmap other than UTF-8."
			ewarn "This may trigger build failures in some python packages."
			return 1
		fi

		# Try English first, then everything else.
		local lang locales="en_US.UTF-8 $(locale -a)"

		for lang in ${locales}; do
			if [[ $(LC_CTYPE=${lang} locale charmap 2>/dev/null) == UTF-8 ]]; then
				export LC_CTYPE=${lang}
				return 0
			fi  
		done

		ewarn "Could not find a UTF-8 locale. This may trigger build failures in"
		ewarn "some python packages. Please ensure that a UTF-8 locale is listed in"
		ewarn "/etc/locale.gen and run locale-gen."
		return 1
	fi  

	return 0
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
