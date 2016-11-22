# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == 9999 ]]; then
	MATE_BRANCH=9999
	MATE_THEMES_V=9999
else
	inherit versionator
	MATE_BRANCH="$(get_version_component_range 1-2)"
	MATE_THEMES_V=3
	KEYWORDS="amd64 ~arm x86"
fi

SRC_URI=""
DESCRIPTION="Meta ebuild for MATE, a traditional desktop environment"
HOMEPAGE="http://mate-desktop.org"

LICENSE="metapackage"

SLOT="0"
IUSE="+base -bluetooth gtk3 help +notification +themes +extras"

S="${WORKDIR}"

RDEPEND="
	=mate-base/mate-desktop-${MATE_BRANCH}*:0[gtk3(-)?]
	=mate-base/mate-menus-${MATE_BRANCH}*:0
	=mate-base/mate-panel-${MATE_BRANCH}*:0[gtk3(-)?]
	=mate-base/mate-session-manager-${MATE_BRANCH}*:0[gtk3(-)?]
	=mate-base/mate-settings-daemon-${MATE_BRANCH}*:0[gtk3(-)?]
	=x11-wm/marco-${MATE_BRANCH}*:0[gtk3(-)?]
	base? (
		=mate-base/caja-${MATE_BRANCH}*:0[gtk3(-)?]
		=mate-base/mate-applets-meta-${MATE_BRANCH}*:0[gtk3(-)?]
		=mate-base/mate-control-center-${MATE_BRANCH}*:0[gtk3(-)?]
		=mate-extra/mate-media-${MATE_BRANCH}*:0[gtk3(-)?]
		=x11-misc/mozo-${MATE_BRANCH}*:0[gtk3(-)?]
		=x11-terms/mate-terminal-${MATE_BRANCH}*:0[gtk3(-)?]
	)
	bluetooth? ( net-wireless/blueman:0 )
	themes? (
		=x11-themes/mate-backgrounds-${MATE_BRANCH}*:0
		=x11-themes/mate-icon-theme-${MATE_BRANCH}*:0
		>=x11-themes/mate-themes-meta-${MATE_THEMES_V}:0
	)
	extras? (
		=app-arch/engrampa-${MATE_BRANCH}*:0[gtk3(-)?]
		=app-editors/pluma-${MATE_BRANCH}*:0[gtk3(-)?]
		=app-text/atril-${MATE_BRANCH}*:0[gtk3(-)?]
		gnome-extra/gnome-calculator:0
		=mate-extra/caja-extensions-${MATE_BRANCH}*:0[gtk3(-)?]
		=mate-extra/mate-netbook-${MATE_BRANCH}*:0[gtk3(-)?]
		=mate-extra/mate-power-manager-${MATE_BRANCH}*:0[gtk3(-)?]
		=mate-extra/mate-screensaver-${MATE_BRANCH}*:0[gtk3(-)?]
		=mate-extra/mate-system-monitor-${MATE_BRANCH}*:0[gtk3(-)?]
		=mate-extra/mate-utils-${MATE_BRANCH}*:0[gtk3(-)?]
		=media-gfx/eom-${MATE_BRANCH}*:0[gtk3(-)?]
		=net-analyzer/mate-netspeed-${MATE_BRANCH}*:0[gtk3(-)?]
		sys-apps/gnome-disk-utility:0
	)
	help? (
		gnome-extra/yelp:0
		=mate-extra/mate-user-guide-${MATE_BRANCH}*:0
	)
"

PDEPEND="
	notification? ( =x11-misc/mate-notification-daemon-${MATE_BRANCH}*:0[gtk3(-)?] )
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
	elog "Some packages that are not included in this meta-package but may be of interest:"
	elog "		mate-extra/caja-dropbox"
	elog "		mate-extra/mate-user-share"
}
