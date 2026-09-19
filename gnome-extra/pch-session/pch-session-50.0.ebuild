# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils

DESCRIPTION="Unofficial gnome based session with different default settings and extensions"
HOMEPAGE="https://gitlab.com/pachoramos/pch-session"
SRC_URI="https://gitlab.com/pachoramos/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="breeze qt6 wayland webp"

RDEPEND="
	>=gnome-base/gnome-shell-50
	>=gnome-extra/gnome-shell-extensions-50
	>=gnome-extra/gnome-shell-extension-alphabetical-grid-46.0
	>=gnome-extra/gnome-shell-extension-appindicator-65
	>=gnome-extra/gnome-shell-extension-applications-overview-tooltip-24-r1
	>=gnome-extra/gnome-shell-extension-bing-wallpaper-53
	>=gnome-extra/gnome-shell-extension-dash-to-panel-74
	>=gnome-extra/gnome-shell-extension-desktop-icons-ng-51
	>=gnome-extra/gnome-shell-extension-gsconnect-72
	>=gnome-extra/gnome-shell-extension-lockscreen-studio-1.1.2
	>=gnome-extra/gnome-shell-extension-weather-oclock-50.5
	>=gnome-extra/gnome-tweaks-49

	>=gnome-extra/gnome-clocks-50
	>=media-fonts/fonts-meta-3
	|| (
		sys-apps/tuned[ppd]
		sys-power/power-profiles-daemon
	)
	x11-themes/papirus-icon-theme

	breeze? ( kde-plasma/breeze:6 )
	qt6? (
		x11-themes/QGnomePlatform
		wayland? ( x11-themes/QAdwaitaDecorations )
	)
	webp? ( gui-libs/gdk-pixbuf-loader-webp )
"

pkg_preinst() {
	gnome2_schemas_update
}

src_install() {
	insinto /
	doins -r usr/ etc/
	einstalldocs
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
