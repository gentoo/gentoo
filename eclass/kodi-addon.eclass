# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: kodi-addon.eclass
# @MAINTAINER:
# candrews@gentoo.org
# @BLURB: Helper for correct building and (importantly) installing Kodi addon packages.
# @DESCRIPTION:
# Provides a src_configure function for correct CMake configuration

inherit multilib cmake-utils

case "${EAPI:-0}" in
	4|5|6)
		EXPORT_FUNCTIONS src_configure
		;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

# @FUNCTION: kodi-addon_src_configure
# @DESCRIPTION:
# Configure handling for Kodi addons
kodi-addon_src_configure() {

	mycmakeargs+=(
		-DCMAKE_INSTALL_LIBDIR=$(get_libdir)/kodi
	)

	cmake-utils_src_configure
}
