# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: fdo-mime.eclass
# @MAINTAINER:
# freedesktop-bugs@gentoo.org
# @AUTHOR:
# Original author: foser <foser@gentoo.org>
# @BLURB: Utility eclass to update the desktop mime info as laid out in the freedesktop specs & implementations

# @FUNCTION: fdo-mime_desktop_database_update
# @DESCRIPTION:
# Updates the desktop database.
# Generates a list of mimetypes linked to applications that can handle them
fdo-mime_desktop_database_update() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EROOT="${ROOT}"
	if [ -x "${EPREFIX}/usr/bin/update-desktop-database" ]
	then
		einfo "Updating desktop mime database ..."
		"${EPREFIX}/usr/bin/update-desktop-database" -q "${EROOT}usr/share/applications"
	fi
}

# @FUNCTION: fdo-mime_mime_database_update
# @DESCRIPTION:
# Update the mime database.
# Creates a general list of mime types from several sources
fdo-mime_mime_database_update() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EROOT="${ROOT}"
	if [ -x "${EPREFIX}/usr/bin/update-mime-database" ]
	then
		einfo "Updating shared mime info database ..."
		"${EPREFIX}/usr/bin/update-mime-database" "${EROOT}usr/share/mime"
	fi
}
