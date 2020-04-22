# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2-utils

DESCRIPTION="Unofficial gnome based session with different default settings and extensions"
HOMEPAGE="https://gitlab.com/pachoramos/pch-session"
SRC_URI="https://gitlab.com/pachoramos/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# gnome-extra/gnome-tweaks to configure extensions easily
RDEPEND="
	>=gnome-base/gnome-shell-3.34
	>=gnome-extra/gnome-shell-extensions-3.34
	>=gnome-extra/gnome-shell-extension-applications-overview-tooltip-6
	>=gnome-extra/gnome-shell-extension-bluetooth-quick-connect-10
	>=gnome-extra/gnome-shell-extension-dash-to-panel-26
	>=gnome-extra/gnome-shell-extension-desktop-icons-19.10.2
	>=gnome-extra/gnome-shell-extension-gsconnect-33
	>=gnome-extra/gnome-shell-extensions-topicons-plus-22_p20190929
	>=gnome-extra/gnome-tweaks-3.32
"
BDEPEND=""
DEPEND=""

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
