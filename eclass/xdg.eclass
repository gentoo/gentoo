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

	has ${EAPI:-0} 6 && default
}

# @FUNCTION: xdg_pkg_preinst
# @DESCRIPTION:
# Finds .desktop and mime info files for later handling in pkg_postinst.
# Locations are stored in XDG_ECLASS_DESKTOPFILES and XDG_ECLASS_MIMEINFOFILES
# respectively.
xdg_pkg_preinst() {
	local f

	XDG_ECLASS_DESKTOPFILES=()
	while IFS= read -r -d '' f; do
		XDG_ECLASS_DESKTOPFILES+=( ${f} )
	done < <(cd "${D}" && find 'usr/share/applications' -type f -print0 2>/dev/null)

	XDG_ECLASS_MIMEINFOFILES=()
	while IFS= read -r -d '' f; do
		XDG_ECLASS_MIMEINFOFILES+=( ${f} )
	done < <(cd "${D}" && find 'usr/share/mime' -type f -print0 2>/dev/null)

	export XDG_ECLASS_DESKTOPFILES XDG_ECLASS_MIMEINFOFILES
}

# @FUNCTION: xdg_pkg_postinst
# @DESCRIPTION:
# Handle desktop and mime info database updates.
xdg_pkg_postinst() {
	if [[ ${#XDG_ECLASS_DESKTOPFILES[@]} -gt 0 ]]; then
		xdg_desktop_database_update
	else
		debug-print "No .desktop files to add to database"
	fi

	if [[ ${#XDG_ECLASS_MIMEINFOFILES[@]} -gt 0 ]]; then
		xdg_mimeinfo_database_update
	else
		debug-print "No mime info files to add to database"
	fi
}

# @FUNCTION: xdg_pkg_postrm
# @DESCRIPTION:
# Handle desktop and mime info database updates.
xdg_pkg_postrm() {
	if [[ ${#XDG_ECLASS_DESKTOPFILES[@]} -gt 0 ]]; then
		xdg_desktop_database_update
	else
		debug-print "No .desktop files to add to database"
	fi

	if [[ ${#XDG_ECLASS_MIMEINFOFILES[@]} -gt 0 ]]; then
		xdg_mimeinfo_database_update
	else
		debug-print "No mime info files to add to database"
	fi
}

