# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2-utils

DESCRIPTION="Unofficial gnome based session with different default settings and extensions"
HOMEPAGE="https://gitlab.com/pachoramos/pch-session"
SRC_URI="https://gitlab.com/pachoramos/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt5 webp"

RDEPEND="
	>=gnome-base/gnome-shell-41
	>=gnome-extra/gnome-shell-extensions-41
	>=gnome-extra/gnome-shell-extension-alphabetical-grid-17.0
	>=gnome-extra/gnome-shell-extension-appindicator-41
	>=gnome-extra/gnome-shell-extension-applications-overview-tooltip-14
	>=gnome-extra/gnome-shell-extension-bing-wallpaper-36
	>=gnome-extra/gnome-shell-extension-bluetooth-quick-connect-23
	>=gnome-extra/gnome-shell-extension-control-blur-effect-on-lock-screen-20211111
	>=gnome-extra/gnome-shell-extension-dash-to-panel-45
	>=gnome-extra/gnome-shell-extension-desktop-icons-ng-0.24.0
	>=gnome-extra/gnome-shell-extension-gsconnect-48
	>=gnome-extra/gnome-shell-extension-weather-in-the-clock-20211108
	>=gnome-extra/gnome-tweaks-40.0
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
