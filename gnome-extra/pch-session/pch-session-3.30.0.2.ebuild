# Copyright 2019 Gentoo Authors
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

# gnome-extra/gnome-tweaks to configure extensions easily
RDEPEND="
	>=gnome-base/gnome-shell-3.30
	gnome-extra/gnome-shell-extensions
	gnome-extra/gnome-shell-extension-applications-overview-tooltip
	gnome-extra/gnome-shell-extension-dash-to-panel
	gnome-extra/gnome-shell-extension-desktop-icons
	gnome-extra/gnome-shell-extension-gsconnect
	gnome-extra/gnome-shell-extensions-topicons-plus
	gnome-extra/gnome-tweaks
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
