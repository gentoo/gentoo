# Copyright 2019-2024 Gentoo Authors
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
	>=gnome-base/gnome-shell-45
	>=gnome-extra/gnome-shell-extensions-45
	>=gnome-extra/gnome-shell-extension-alphabetical-grid-36.0
	>=gnome-extra/gnome-shell-extension-appindicator-57
	>=gnome-extra/gnome-shell-extension-applications-overview-tooltip-19
	>=gnome-extra/gnome-shell-extension-bing-wallpaper-48
	>=gnome-extra/gnome-shell-extension-dash-to-panel-59
	>=gnome-extra/gnome-shell-extension-desktop-icons-ng-47.0.7
	>=gnome-extra/gnome-shell-extension-gsconnect-56
	>=gnome-extra/gnome-shell-extension-weather-in-the-clock-20221024-r2
	>=gnome-extra/gnome-tweaks-45.0

	>=gnome-extra/gnome-clocks-45.0
	>=media-fonts/fonts-meta-2
	sys-power/power-profiles-daemon
	x11-themes/papirus-icon-theme

	qt5? ( x11-themes/adwaita-qt )
	webp? ( gui-libs/gdk-pixbuf-loader-webp )
"

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
