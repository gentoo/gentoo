# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit fdo-mime gnome2-utils qmake-utils

DESCRIPTION="utility that merges application menus, your desktop and even your file manager"
HOMEPAGE="http://www.launchy.net/"
SRC_URI="http://www.launchy.net/downloads/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtgui:4
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	dev-libs/boost
	x11-proto/xproto
"

PATCHES=(
	"${FILESDIR}"/${P}-underlink.patch
	"${FILESDIR}"/${P}-prefix-and-libdir.patch
)

src_configure() {
	eqmake4 Launchy.pro PREFIX="${EPREFIX}"/usr LIBDIR="$(get_libdir)"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
