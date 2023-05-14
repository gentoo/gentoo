# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2-utils

DESCRIPTION="Unofficial gnome based session with different default settings and extensions"
HOMEPAGE="https://gitlab.com/pachoramos/pch-session"
SRC_URI="https://gitlab.com/pachoramos/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="qt5 webp"

RDEPEND="
	>=gnome-base/gnome-shell-44
	>=gnome-extra/gnome-shell-extensions-44
	>=gnome-extra/gnome-shell-extension-alphabetical-grid-29.0
	>=gnome-extra/gnome-shell-extension-appindicator-53
	>=gnome-extra/gnome-shell-extension-applications-overview-tooltip-16-r1
	>=gnome-extra/gnome-shell-extension-bing-wallpaper-45
	>=gnome-extra/gnome-shell-extension-dash-to-panel-56
	>=gnome-extra/gnome-shell-extension-desktop-icons-ng-47.0.2
	>=gnome-extra/gnome-shell-extension-gsconnect-55
	>=gnome-extra/gnome-shell-extension-weather-in-the-clock-20221024-r1
	>=gnome-extra/gnome-tweaks-40.10

	>=gnome-extra/gnome-clocks-44.0
	>=media-fonts/fonts-meta-2
	sys-power/power-profiles-daemon
	x11-themes/papirus-icon-theme

	qt5? ( x11-themes/adwaita-qt )
	webp? ( gui-libs/gdk-pixbuf-loader-webp )
"
BDEPEND=""
DEPEND=""

pkg_preinst() {
	gnome2_schemas_update
}

src_install() {
	insinto /usr
	doins -r usr/.
	einstalldocs
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
