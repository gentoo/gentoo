# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: qmake-utils.eclass
# @MAINTAINER:
# qt@gentoo.org
# @AUTHOR:
# Davide Pesavento <pesa@gentoo.org>
# @SUPPORTED_EAPIS: 7
# @BLURB: Common functions for qmake-based packages.
# @DESCRIPTION:
# Utility eclass providing wrapper functions for Qt5 qmake.
#
# This eclass does not set any metadata variables nor export any phase
# functions. It can be inherited safely.

if [[ -z ${_QMAKE_UTILS_ECLASS} ]]; then
_QMAKE_UTILS_ECLASS=1

case ${EAPI} in
	7) ;;
	*) die "EAPI=${EAPI:-0} is not supported" ;;
esac

inherit toolchain-funcs

# @FUNCTION: _qmake-utils_banned_func
# @INTERNAL
# @DESCRIPTION:
# Banned functions are banned.
_qmake-utils_banned_func() {
	die "${FUNCNAME[1]} is banned in EAPI 7 and later"
}

# @FUNCTION: qt4_get_bindir
# @INTERNAL
# @DESCRIPTION:
# Banned.
qt4_get_bindir() {
	_qmake-utils_banned_func
}

# @FUNCTION: qt4_get_headerdir
# @INTERNAL
# @DESCRIPTION:
# Banned.
qt4_get_headerdir() {
	_qmake-utils_banned_func
}

# @FUNCTION: qt4_get_libdir
# @INTERNAL
# @DESCRIPTION:
# Banned.
qt4_get_libdir() {
	_qmake-utils_banned_func
}

# @FUNCTION: qt4_get_mkspecsdir
# @INTERNAL
# @DESCRIPTION:
# Banned.
qt4_get_mkspecsdir() {
	_qmake-utils_banned_func
}

# @FUNCTION: qt4_get_plugindir
# @INTERNAL
# @DESCRIPTION:
# Banned.
qt4_get_plugindir() {
	_qmake-utils_banned_func
}

# @FUNCTION: qt5_get_bindir
# @DESCRIPTION:
# Echoes the directory where Qt5 binaries are installed.
# EPREFIX is already prepended to the returned path.
qt5_get_bindir() {
	echo ${EPREFIX}$(qt5_get_libdir)/qt5/bin
}

# @FUNCTION: qt5_get_headerdir
# @DESCRIPTION:
# Echoes the directory where Qt5 headers are installed.
qt5_get_headerdir() {
	echo /usr/include/qt5
}

# @FUNCTION: qt5_get_libdir
# @DESCRIPTION:
# Echoes the directory where Qt5 libraries are installed.
qt5_get_libdir() {
	echo /usr/$(get_libdir)
}

# @FUNCTION: qt5_get_mkspecsdir
# @DESCRIPTION:
# Echoes the directory where Qt5 mkspecs are installed.
qt5_get_mkspecsdir() {
	echo $(qt5_get_libdir)/qt5/mkspecs
}

# @FUNCTION: qt5_get_plugindir
# @DESCRIPTION:
# Echoes the directory where Qt5 plugins are installed.
qt5_get_plugindir() {
	echo $(qt5_get_libdir)/qt5/plugins
}

# @FUNCTION: qmake-utils_find_pro_file
# @INTERNAL
# @DESCRIPTION:
# Banned.
qmake-utils_find_pro_file() {
	_qmake-utils_banned_func
}

# @FUNCTION: eqmake4
# @INTERNAL
# @DESCRIPTION:
# Banned.
eqmake4() {
	_qmake-utils_banned_func
}

# @FUNCTION: eqmake5
# @USAGE: [arguments for qmake]
# @DESCRIPTION:
# Wrapper for Qt5's qmake. All arguments are passed to qmake.
#
# For recursive build systems, i.e. those based on the subdirs template,
# you should run eqmake5 on the top-level project file only, unless you
# have a valid reason to do otherwise. During the building, qmake will
# be automatically re-invoked with the right arguments on every directory
# specified inside the top-level project file.
eqmake5() {
	debug-print-function ${FUNCNAME} "$@"

	ebegin "Running qmake"

	"$(qt5_get_bindir)"/qmake \
		-makefile \
		QMAKE_AR="$(tc-getAR) cqs" \
		QMAKE_CC="$(tc-getCC)" \
		QMAKE_LINK_C="$(tc-getCC)" \
		QMAKE_LINK_C_SHLIB="$(tc-getCC)" \
		QMAKE_CXX="$(tc-getCXX)" \
		QMAKE_LINK="$(tc-getCXX)" \
		QMAKE_LINK_SHLIB="$(tc-getCXX)" \
		QMAKE_OBJCOPY="$(tc-getOBJCOPY)" \
		QMAKE_RANLIB= \
		QMAKE_STRIP= \
		QMAKE_CFLAGS="${CFLAGS}" \
		QMAKE_CFLAGS_RELEASE= \
		QMAKE_CFLAGS_DEBUG= \
		QMAKE_CXXFLAGS="${CXXFLAGS}" \
		QMAKE_CXXFLAGS_RELEASE= \
		QMAKE_CXXFLAGS_DEBUG= \
		QMAKE_LFLAGS="${LDFLAGS}" \
		QMAKE_LFLAGS_RELEASE= \
		QMAKE_LFLAGS_DEBUG= \
		"$@"

	if ! eend $? ; then
		echo
		eerror "Running qmake has failed! (see above for details)"
		eerror "This shouldn't happen - please send a bug report to https://bugs.gentoo.org/"
		echo
		die "eqmake5 failed"
	fi
}

fi
