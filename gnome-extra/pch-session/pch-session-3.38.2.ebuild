# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2-utils

DESCRIPTION="Unofficial gnome based session with different default settings and extensions"
HOMEPAGE="https://gitlab.com/pachoramos/pch-session"
SRC_URI="https://gitlab.com/pachoramos/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	>=gnome-base/gnome-shell-3.38
	>=gnome-extra/gnome-shell-extensions-3.38
	>=gnome-extra/gnome-shell-extension-applications-overview-tooltip-10
	>=gnome-extra/gnome-shell-extension-bing-wallpaper-27
	>=gnome-extra/gnome-shell-extension-bluetooth-quick-connect-16
	>=gnome-extra/gnome-shell-extension-control-blur-effect-on-lock-screen-20200901
	>=gnome-extra/gnome-shell-extension-dash-to-panel-40
	>=gnome-extra/gnome-shell-extension-desktop-icons-20.04.0-r2
	>=gnome-extra/gnome-shell-extension-gsconnect-44
	>=gnome-extra/gnome-shell-extensions-topicons-plus-27
	>=gnome-extra/gnome-tweaks-3.34
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
