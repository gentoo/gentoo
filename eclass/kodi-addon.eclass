# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: kodi-addon.eclass
# @MAINTAINER:
# candrews@gentoo.org
# @SUPPORTED_EAPIS: 4 5 6 7
# @BLURB: Helper for correct building and (importantly) installing Kodi addon packages.
# @DESCRIPTION:
# Provides a src_configure function for correct CMake configuration

case "${EAPI:-0}" in
	4|5|6)
		inherit cmake-utils multilib
		;;
	7)
		inherit cmake
		;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

EXPORT_FUNCTIONS src_configure

# @FUNCTION: kodi-addon_src_configure
# @DESCRIPTION:
# Configure handling for Kodi addons
kodi-addon_src_configure() {

	mycmakeargs+=(
		-DCMAKE_INSTALL_LIBDIR=${EPREFIX%/}/usr/$(get_libdir)/kodi
	)

	case ${EAPI} in
		4|5|6) cmake-utils_src_configure ;;
		7) cmake_src_configure ;;
	esac
}
