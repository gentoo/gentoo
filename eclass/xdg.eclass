# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: xdg.eclass
# @MAINTAINER:
# freedesktop-bugs@gentoo.org
# @AUTHOR:
# Original author: Gilles Dartiguelongue <eva@gentoo.org>
# @SUPPORTED_EAPIS: 6 7 8
# @PROVIDES: xdg-utils
# @BLURB: Provides phases for XDG compliant packages.
# @DESCRIPTION:
# Utility eclass to update the desktop, icon and shared mime info as laid
# out in the freedesktop specs & implementations

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_XDG_ECLASS} ]]; then
_XDG_ECLASS=1

inherit xdg-utils

# Avoid dependency loop as both depend on glib-2
[[ ${CATEGORY}/${P} != dev-libs/glib-2.* ]] && _XDG_DEPEND="
	dev-util/desktop-file-utils
	x11-misc/shared-mime-info
"

case ${EAPI} in
	6|7)
		# src_prepare is only exported in EAPI < 8.
		# @FUNCTION: xdg_src_prepare
		# @DESCRIPTION:
		# Prepare sources to work with XDG standards.
		# Note that this function is only defined and exported in EAPIs < 8.
		xdg_src_prepare() {
			xdg_environment_reset
			default
		}

		EXPORT_FUNCTIONS src_prepare

		DEPEND="${_XDG_DEPEND}"
		;;
	*)
		xdg_src_prepare() {
			die "Called xdg_src_prepare in EAPI >= 8"
		}

		IDEPEND="${_XDG_DEPEND}"
		;;
esac
unset _XDG_DEPEND

# @FUNCTION: xdg_pkg_preinst
# @DESCRIPTION:
# Finds .desktop, icon and mime info files for later handling in pkg_postinst.
# Locations are stored in XDG_ECLASS_DESKTOPFILES, XDG_ECLASS_ICONFILES
# and XDG_ECLASS_MIMEINFOFILES respectively.
xdg_pkg_preinst() {
	local f

	XDG_ECLASS_DESKTOPFILES=()
	while IFS= read -r -d '' f; do
		XDG_ECLASS_DESKTOPFILES+=( ${f} )
	done < <(cd "${ED}" && find 'usr/share/applications' -type f -print0 2>/dev/null)

	XDG_ECLASS_ICONFILES=()
	while IFS= read -r -d '' f; do
		XDG_ECLASS_ICONFILES+=( ${f} )
	done < <(cd "${ED}" && find 'usr/share/icons' -type f -print0 2>/dev/null)

	XDG_ECLASS_MIMEINFOFILES=()
	while IFS= read -r -d '' f; do
		XDG_ECLASS_MIMEINFOFILES+=( ${f} )
	done < <(cd "${ED}" && find 'usr/share/mime' -type f -print0 2>/dev/null)
}

# @FUNCTION: xdg_pkg_postinst
# @DESCRIPTION:
# Handle desktop, icon and mime info database updates.
xdg_pkg_postinst() {
	if [[ ${#XDG_ECLASS_DESKTOPFILES[@]} -gt 0 ]]; then
		xdg_desktop_database_update
	else
		debug-print "No .desktop files to add to database"
	fi

	if [[ ${#XDG_ECLASS_ICONFILES[@]} -gt 0 ]]; then
		xdg_icon_cache_update
	else
		debug-print "No icon files to add to cache"
	fi

	if [[ ${#XDG_ECLASS_MIMEINFOFILES[@]} -gt 0 ]]; then
		xdg_mimeinfo_database_update
	else
		debug-print "No mime info files to add to database"
	fi
}

# @FUNCTION: xdg_pkg_postrm
# @DESCRIPTION:
# Handle desktop, icon and mime info database updates.
xdg_pkg_postrm() {
	if [[ ${#XDG_ECLASS_DESKTOPFILES[@]} -gt 0 ]]; then
		xdg_desktop_database_update
	else
		debug-print "No .desktop files to add to database"
	fi

	if [[ ${#XDG_ECLASS_ICONFILES[@]} -gt 0 ]]; then
		xdg_icon_cache_update
	else
		debug-print "No icon files to add to cache"
	fi

	if [[ ${#XDG_ECLASS_MIMEINFOFILES[@]} -gt 0 ]]; then
		xdg_mimeinfo_database_update
	else
		debug-print "No mime info files to add to database"
	fi
}

fi

EXPORT_FUNCTIONS pkg_preinst pkg_postinst pkg_postrm
