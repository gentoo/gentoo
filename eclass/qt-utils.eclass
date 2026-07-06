# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: qt-utils.eclass
# @MAINTAINER:
# qt@gentoo.org
# @AUTHOR:
# Davide Pesavento <pesa@gentoo.org>
# @SUPPORTED_EAPIS: 8 9
# @BLURB: Qt related helpers.
# @DESCRIPTION:
# Utility eclass providing query functions for Qt.
#
# This eclass does not set any metadata variables nor export any phase
# functions. It can be inherited safely.

if [[ -z ${_QT_UTILS_ECLASS} ]]; then
_QT_UTILS_ECLASS=1

case ${EAPI} in
	8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @FUNCTION: qt6_get_bindir
# @DESCRIPTION:
# Echoes the directory where Qt6 binaries are installed.
# EPREFIX is already prepended to the returned path.
qt6_get_bindir() {
	echo "${EPREFIX}$(qt6_get_libdir)/qt6/bin"
}

# @FUNCTION: qt6_get_headerdir
# @DESCRIPTION:
# Echoes the directory where Qt6 headers are installed.
qt6_get_headerdir() {
	echo "/usr/include/qt6"
}

# @FUNCTION: qt6_get_libdir
# @DESCRIPTION:
# Echoes the directory where Qt6 libraries are installed.
qt6_get_libdir() {
	echo "/usr/$(get_libdir)"
}

# @FUNCTION: qt6_get_libexecdir
# @DESCRIPTION:
# Echoes the directory where Qt6 libexec bins are installed.
qt6_get_libexecdir() {
	echo "$(qt6_get_libdir)/qt6/libexec"
}

# @FUNCTION: qt6_get_mkspecsdir
# @DESCRIPTION:
# Echoes the directory where Qt6 mkspecs are installed.
qt6_get_mkspecsdir() {
	echo "$(qt6_get_libdir)/qt6/mkspecs"
}

# @FUNCTION: qt6_get_plugindir
# @DESCRIPTION:
# Echoes the directory where Qt6 plugins are installed.
qt6_get_plugindir() {
	echo "$(qt6_get_libdir)/qt6/plugins"
}

fi
