# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit fdo-mime gnome2-utils qt4-r2

DESCRIPTION="utility that merges application menus, your desktop and even your file manager"
HOMEPAGE="http://www.launchy.net/"
SRC_URI="http://www.launchy.net/downloads/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtgui:4"
DEPEND="${RDEPEND}
	dev-libs/boost"

PATCHES=( "${FILESDIR}"/${P}-underlink.patch )

src_prepare() {
	sed -i -e "s:lib/launchy:$(get_libdir)/launchy:" src/src.pro \
		platforms/unix/unix.pro \
		plugins/*/*.pro || die "sed failed"
	qt4-r2_src_prepare
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
