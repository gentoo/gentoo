# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2-utils

DESCRIPTION="Unofficial gnome based session with different default settings and extensions"
HOMEPAGE="https://gitlab.com/pachoramos/pch-session"
SRC_URI="https://gitlab.com/pachoramos/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="bluetooth qt5 webp"

RDEPEND="
	>=gnome-base/gnome-shell-43
	>=gnome-extra/gnome-shell-extensions-43
	>=gnome-extra/gnome-shell-extension-alphabetical-grid-26.0
	>=gnome-extra/gnome-shell-extension-appindicator-46
	>=gnome-extra/gnome-shell-extension-applications-overview-tooltip-16
	>=gnome-extra/gnome-shell-extension-bing-wallpaper-44
	>=gnome-extra/gnome-shell-extension-dash-to-panel-52
	>=gnome-extra/gnome-shell-extension-desktop-icons-ng-47
	>=gnome-extra/gnome-shell-extension-gsconnect-54
	>=gnome-extra/gnome-shell-extension-weather-in-the-clock-20221024
	>=gnome-extra/gnome-tweaks-40.10

	>=gnome-extra/gnome-clocks-43.0
	>=media-fonts/fonts-meta-2
	x11-themes/papirus-icon-theme

	bluetooth? ( >=gnome-extra/gnome-shell-extension-bluetooth-quick-connect-30 )
	qt5? ( x11-themes/adwaita-qt )
	webp? ( gui-libs/gdk-pixbuf-loader-webp )
"
BDEPEND=""
DEPEND=""

src_prepare() {
	default
	if ! use bluetooth; then
		sed -i -e \
			's:"bluetooth-quick-connect@bjarosze.gmail.com",::g' \
			usr/share/gnome-shell/modes/pch*.json || die
	fi
}

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
