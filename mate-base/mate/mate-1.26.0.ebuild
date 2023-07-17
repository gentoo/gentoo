# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999 ]]; then
	MATE_BRANCH=9999
	MATE_THEMES_V=9999
else
	MATE_BRANCH="$(ver_cut 1-2)"
	MATE_THEMES_V=3
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"
fi

SRC_URI=""
DESCRIPTION="Meta ebuild for MATE, a traditional desktop environment"
HOMEPAGE="https://mate-desktop.org"

LICENSE="metapackage"

SLOT="0"
IUSE="+base bluetooth help +notification +themes +extras"

S="${WORKDIR}"

RDEPEND="
	=mate-base/mate-desktop-${MATE_BRANCH}*
	=mate-base/mate-menus-${MATE_BRANCH}*
	=mate-base/mate-panel-${MATE_BRANCH}*
	=mate-base/mate-session-manager-${MATE_BRANCH}*
	=mate-base/mate-settings-daemon-${MATE_BRANCH}*
	=x11-wm/marco-${MATE_BRANCH}*
	base? (
		=mate-base/caja-${MATE_BRANCH}*
		=mate-base/mate-applets-meta-${MATE_BRANCH}*
		=mate-base/mate-control-center-${MATE_BRANCH}*
		=mate-extra/mate-media-${MATE_BRANCH}*
		=x11-misc/mozo-${MATE_BRANCH}*
		=x11-terms/mate-terminal-${MATE_BRANCH}*
	)
	bluetooth? ( net-wireless/blueman )
	themes? (
		=x11-themes/mate-backgrounds-${MATE_BRANCH}*
		=x11-themes/mate-icon-theme-${MATE_BRANCH}*
	)
	extras? (
		=app-arch/engrampa-${MATE_BRANCH}*
		=app-editors/pluma-${MATE_BRANCH}*
		=app-text/atril-${MATE_BRANCH}*
		=mate-extra/caja-extensions-${MATE_BRANCH}*
		=mate-extra/mate-calc-${MATE_BRANCH}*
		=mate-extra/mate-netbook-${MATE_BRANCH}*
		=mate-extra/mate-power-manager-${MATE_BRANCH}*
		=mate-extra/mate-screensaver-${MATE_BRANCH}*
		=mate-extra/mate-system-monitor-${MATE_BRANCH}*
		=mate-extra/mate-utils-${MATE_BRANCH}*
		=media-gfx/eom-${MATE_BRANCH}*
	)
	help? (
		gnome-extra/yelp
		=mate-extra/mate-user-guide-${MATE_BRANCH}*
	)
"

PDEPEND="
	notification? ( =x11-misc/mate-notification-daemon-${MATE_BRANCH}* )
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
	elog "		mate-extra/caja-admin"
}
