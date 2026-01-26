# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: qmake-utils.eclass
# @MAINTAINER:
# qt@gentoo.org
# @AUTHOR:
# Davide Pesavento <pesa@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: Common functions for qmake-based packages.
# @DESCRIPTION:
# Utility eclass providing wrapper functions for Qt qmake.
#
# This eclass does not set any metadata variables nor export any phase
# functions. It can be inherited safely.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_QMAKE_UTILS_ECLASS} ]]; then
_QMAKE_UTILS_ECLASS=1

inherit toolchain-funcs

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

# @FUNCTION: qt5_get_qmake_args
# @DESCRIPTION:
# Echoes a multi-line string containing arguments to pass to qmake.
qt5_get_qmake_args() {
	cat <<-EOF
		QMAKE_AR="$(tc-getAR) cqs"
		QMAKE_CC="$(tc-getCC)"
		QMAKE_LINK_C="$(tc-getCC)"
		QMAKE_LINK_C_SHLIB="$(tc-getCC)"
		QMAKE_CXX="$(tc-getCXX)"
		QMAKE_LINK="$(tc-getCXX)"
		QMAKE_LINK_SHLIB="$(tc-getCXX)"
		QMAKE_OBJCOPY="$(tc-getOBJCOPY)"
		QMAKE_RANLIB=
		QMAKE_STRIP=
		QMAKE_CFLAGS="${CFLAGS}"
		QMAKE_CFLAGS_RELEASE=
		QMAKE_CFLAGS_DEBUG=
		QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO=
		QMAKE_CXXFLAGS="${CXXFLAGS}"
		QMAKE_CXXFLAGS_RELEASE=
		QMAKE_CXXFLAGS_DEBUG=
		QMAKE_CXXFLAGS_RELEASE_WITH_DEBUGINFO=
		QMAKE_LFLAGS="${LDFLAGS}"
		QMAKE_LFLAGS_RELEASE=
		QMAKE_LFLAGS_DEBUG=
		QMAKE_LFLAGS_RELEASE_WITH_DEBUGINFO=
	EOF
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

	local -a args
	mapfile -t args <<<"$(qt5_get_qmake_args)"
	# NB: we're passing literal quotes in but qmake doesn't seem to mind
	"$(qt5_get_bindir)"/qmake -makefile "${args[@]}" "$@"

	if ! eend $? ; then
		echo
		eerror "Running qmake has failed! (see above for details)"
		eerror "This shouldn't happen - please send a bug report to https://bugs.gentoo.org/"
		echo
		die "eqmake5 failed"
	fi
}

# @FUNCTION: qt6_get_bindir
# @DESCRIPTION:
# Echoes the directory where Qt6 binaries are installed.
# EPREFIX is already prepended to the returned path.
qt6_get_bindir() {
	echo ${EPREFIX}$(qt6_get_libdir)/qt6/bin
}

# @FUNCTION: qt6_get_headerdir
# @DESCRIPTION:
# Echoes the directory where Qt6 headers are installed.
qt6_get_headerdir() {
	echo /usr/include/qt6
}

# @FUNCTION: qt6_get_libdir
# @DESCRIPTION:
# Echoes the directory where Qt6 libraries are installed.
qt6_get_libdir() {
	echo /usr/$(get_libdir)
}

# @FUNCTION: qt6_get_libexecdir
# @DESCRIPTION:
# Echoes the directory where Qt6 libexec bins are installed.
qt6_get_libexecdir() {
	echo $(qt6_get_libdir)/qt6/libexec
}

# @FUNCTION: qt6_get_mkspecsdir
# @DESCRIPTION:
# Echoes the directory where Qt6 mkspecs are installed.
qt6_get_mkspecsdir() {
	echo $(qt6_get_libdir)/qt6/mkspecs
}

# @FUNCTION: qt6_get_plugindir
# @DESCRIPTION:
# Echoes the directory where Qt6 plugins are installed.
qt6_get_plugindir() {
	echo $(qt6_get_libdir)/qt6/plugins
}

# @FUNCTION: qt6_get_qmake_args
# @DESCRIPTION:
# Echoes a multi-line string containing arguments to pass to qmake.
qt6_get_qmake_args() {
	cat <<-EOF
		QMAKE_AR="$(tc-getAR) cqs"
		QMAKE_CC="$(tc-getCC)"
		QMAKE_LINK_C="$(tc-getCC)"
		QMAKE_LINK_C_SHLIB="$(tc-getCC)"
		QMAKE_CXX="$(tc-getCXX)"
		QMAKE_LINK="$(tc-getCXX)"
		QMAKE_LINK_SHLIB="$(tc-getCXX)"
		QMAKE_OBJCOPY="$(tc-getOBJCOPY)"
		QMAKE_RANLIB=
		QMAKE_STRIP=
		QMAKE_CFLAGS="${CFLAGS}"
		QMAKE_CFLAGS_RELEASE=
		QMAKE_CFLAGS_DEBUG=
		QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO=
		QMAKE_CXXFLAGS="${CXXFLAGS}"
		QMAKE_CXXFLAGS_RELEASE=
		QMAKE_CXXFLAGS_DEBUG=
		QMAKE_CXXFLAGS_RELEASE_WITH_DEBUGINFO=
		QMAKE_LFLAGS="${LDFLAGS}"
		QMAKE_LFLAGS_RELEASE=
		QMAKE_LFLAGS_DEBUG=
		QMAKE_LFLAGS_RELEASE_WITH_DEBUGINFO=
	EOF
}

# @FUNCTION: eqmake6
# @USAGE: [arguments for qmake]
# @DESCRIPTION:
# Wrapper for Qt6's qmake. All arguments are passed to qmake.
#
# For recursive build systems, i.e. those based on the subdirs template,
# you should run eqmake6 on the top-level project file only, unless you
# have a valid reason to do otherwise. During the building, qmake will
# be automatically re-invoked with the right arguments on every directory
# specified inside the top-level project file.
eqmake6() {
	debug-print-function ${FUNCNAME} "$@"

	ebegin "Running qmake"

	local -a args
	mapfile -t args <<<"$(qt6_get_qmake_args)"
	# NB: we're passing literal quotes in but qmake doesn't seem to mind
	"$(qt6_get_bindir)"/qmake -makefile "${args[@]}" "$@"

	if ! eend $? ; then
		echo
		eerror "Running qmake has failed! (see above for details)"
		eerror "This shouldn't happen - please send a bug report to https://bugs.gentoo.org/"
		echo
		die "eqmake6 failed"
	fi
}

fi
