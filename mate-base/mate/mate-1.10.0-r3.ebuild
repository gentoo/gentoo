# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit versionator

MATE_MV="$(get_version_component_range 1-2)"

SRC_URI=""
DESCRIPTION="Meta ebuild for MATE, a traditional desktop environment"
HOMEPAGE="http://mate-desktop.org"

LICENSE="metapackage"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+base -bluetooth +notification +themes +extras"

S="${WORKDIR}"

RDEPEND="
	=mate-base/mate-desktop-${MATE_MV}*:0
	=mate-base/mate-menus-${MATE_MV}*:0
	=mate-base/mate-panel-${MATE_MV}*:0
	=mate-base/mate-session-manager-${MATE_MV}*:0
	=mate-base/mate-settings-daemon-${MATE_MV}*:0
	=x11-wm/marco-${MATE_MV}*:0
	base? (
		=mate-base/caja-${MATE_MV}*:0
		=mate-base/mate-applets-meta-${MATE_MV}*:0
		=mate-base/mate-control-center-${MATE_MV}*:0
		=mate-extra/mate-media-${MATE_MV}*:0
		=x11-misc/mozo-${MATE_MV}*:0
		=x11-terms/mate-terminal-${MATE_MV}*:0
	)
	bluetooth? ( net-wireless/blueman:0 )
	themes? (
		=x11-themes/mate-backgrounds-${MATE_MV}*:0
		=x11-themes/mate-icon-theme-${MATE_MV}*:0
		>=x11-themes/mate-themes-meta-3:0
	)
	extras? (
		=app-arch/engrampa-${MATE_MV}*:0
		=app-editors/pluma-${MATE_MV}*:0
		=app-text/atril-${MATE_MV}*:0
		gnome-extra/gnome-calculator:0
		=mate-extra/caja-extensions-${MATE_MV}*:0
		=mate-extra/mate-netbook-${MATE_MV}*:0
		=mate-extra/mate-power-manager-${MATE_MV}*:0
		=mate-extra/mate-screensaver-${MATE_MV}*:0
		=mate-extra/mate-system-monitor-${MATE_MV}*:0
		=mate-extra/mate-utils-${MATE_MV}*:0
		=media-gfx/eom-${MATE_MV}*:0
		=net-analyzer/mate-netspeed-${MATE_MV}*:0
		sys-apps/gnome-disk-utility:0
	)
"

PDEPEND="
	notification? ( x11-misc/mate-notification-daemon )
	virtual/notification-daemon:0"

pkg_postinst() {
	elog "For installation, usage and troubleshooting details regarding MATE;"
	elog "read more about it at Gentoo Wiki: https://wiki.gentoo.org/wiki/MATE"
	elog ""
	if ! has_version x11-misc/mate-notification-daemon; then
		elog "If you experience any issues with notifications, please try using"
		elog "x11-misc/mate-notification-daemon instead your currently installed daemon"
		elog ""
	fi
	elog "MATE 1.10 had some packages renamed, replaced and/or dropped; for more"
	elog "details, see http://mate-desktop.org/blog/2015-06-11-mate-1-10-released/"
	elog ""
	elog "Some packages that are not included in this meta-package but may be of interest:"
	elog "		mate-extra/caja-dropbox"
	elog "		mate-extra/mate-user-share"
}
