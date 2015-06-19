# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mate-base/mate/mate-1.8.0.ebuild,v 1.5 2014/07/02 09:47:11 pacho Exp $

EAPI="5"

inherit multilib

SRC_URI=""
DESCRIPTION="Meta ebuild for MATE, a traditional desktop environment"
HOMEPAGE="http://mate-desktop.org"

LICENSE="metapackage"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+base -bluetooth +themes +extras"

S="${WORKDIR}"

RDEPEND="
	>=mate-base/mate-desktop-1.8:0
	>=mate-base/mate-menus-1.8:0
	>=mate-base/mate-panel-1.8:0
	>=mate-base/mate-session-manager-1.8:0
	>=mate-base/mate-settings-daemon-1.8:0
	>=x11-wm/marco-1.8:0
	base? (
		>=mate-base/caja-1.8:0
		>=mate-base/mate-applets-1.8:0
		>=mate-base/mate-control-center-1.8:0
		>=mate-extra/mate-media-1.8:0
		>=x11-misc/mozo-1.8:0
		>=x11-terms/mate-terminal-1.8:0
	)
	bluetooth? ( net-wireless/blueman:0 )
	themes? (
		>=x11-themes/mate-backgrounds-1.8:0
		>=x11-themes/mate-icon-theme-1.8:0
		>=x11-themes/mate-themes-1.8:0
	)
	extras? (
		>=app-arch/engrampa-1.8:0
		>=app-editors/pluma-1.8:0
		>=app-text/atril-1.8:0
		>=mate-extra/mate-calc-1.8:0
		>=mate-extra/mate-power-manager-1.8:0
		>=mate-extra/mate-screensaver-1.8:0
		>=mate-extra/mate-system-monitor-1.8:0
		>=mate-extra/mate-utils-1.8:0
		>=media-gfx/eom-1.8:0
	)
"

PDEPEND="virtual/notification-daemon:0"

pkg_postinst() {
	elog "For installation, usage and troubleshooting details regarding MATE;"
	elog "read more about it at Gentoo Wiki: https://wiki.gentoo.org/wiki/MATE"
	elog ""
	elog "MATE 1.8 had some packages renamed, replaced and/or dropped; for more"
	elog "details, see http://mate-desktop.org/blog/2014-03-04-mate-1-8-released"
	elog ""
	elog "MATE 1.6 has moved from mateconf to gsettings. This means that the"
	elog "desktop settings and panel applets will return to their default."
	elog "You will have to reconfigure your desktop appearance."
	elog ""
	elog "There is mate-conf-import that converts from mateconf to gsettings."
	elog ""
	elog "For support with mate-conf-import see the following MATE forum topic:"
	elog "http://forums.mate-desktop.org/viewtopic.php?f=16&t=1650"
}
