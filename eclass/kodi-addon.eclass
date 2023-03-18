# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: kodi-addon.eclass
# @MAINTAINER:
# candrews@gentoo.org
# @SUPPORTED_EAPIS: 7
# @PROVIDES: cmake
# @BLURB: Helper for correct building and (importantly) installing Kodi addon packages.
# @DESCRIPTION:
# Provides a src_configure function for correct CMake configuration

case ${EAPI} in
	7) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit cmake

# @FUNCTION: kodi-addon_src_configure
# @DESCRIPTION:
# Configure handling for Kodi addons
kodi-addon_src_configure() {

	mycmakeargs+=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/kodi"
	)

	cmake_src_configure
}

EXPORT_FUNCTIONS src_configure
