# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: xdg.eclass
# @MAINTAINER:
# freedesktop-bugs@gentoo.org
# @AUTHOR:
# Original author: Gilles Dartiguelongue <eva@gentoo.org>
# @BLURB: Provides phases for XDG compliant packages.
# @DESCRIPTION:
# Utility eclass to update the desktop and shared mime info as laid
# out in the freedesktop specs & implementations

inherit xdg-utils

case "${EAPI:-0}" in
	4|5|6)
		EXPORT_FUNCTIONS src_prepare pkg_preinst pkg_postinst pkg_postrm
		;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

DEPEND="
	dev-util/desktop-file-utils
	x11-misc/shared-mime-info
"

# @FUNCTION: xdg_src_prepare
# @DESCRIPTION:
# Prepare sources to work with XDG standards.
xdg_src_prepare() {
	xdg_environment_reset

	has ${EAPI:-0} 6 && eapply_user
}

# @FUNCTION: xdg_pkg_preinst
# @DESCRIPTION:
# Finds .desktop and mime info files for later handling in pkg_postinst.
# Locations are stored in XDG_ECLASS_DESKTOPFILES and XDG_ECLASS_MIMEINFOFILES
# respectively.
xdg_pkg_preinst() {
	export XDG_ECLASS_DESKTOPFILES=( $(cd "${D}" && find 'usr/share/applications' -type f -print0 2> /dev/null) )
	export XDG_ECLASS_MIMEINFOFILES=( $(cd "${D}" && find 'usr/share/mime' -type f -print0 2> /dev/null) )
}

# @FUNCTION: xdg_pkg_postinst
# @DESCRIPTION:
# Handle desktop and mime info database updates.
xdg_pkg_postinst() {
	if [[ -n "${XDG_ECLASS_DESKTOPFILES}" ]]; then
		xdg_desktop_database_update
	else
		debug-print "No .desktop files to add to database"
	fi

	if [[ -n "${XDG_ECLASS_MIMEINFOFILES}" ]]; then
		xdg_mimeinfo_database_update
	else
		debug-print "No mime info files to add to database"
	fi
}

# @FUNCTION: xdg_pkg_postrm
# @DESCRIPTION:
# Handle desktop and mime info database updates.
xdg_pkg_postrm() {
	if [[ -n "${XDG_ECLASS_DESKTOPFILES}" ]]; then
		xdg_desktop_database_update
	else
		debug-print "No .desktop files to add to database"
	fi

	if [[ -n "${XDG_ECLASS_MIMEINFOFILES}" ]]; then
		xdg_mimeinfo_database_update
	else
		debug-print "No mime info files to add to database"
	fi
}

