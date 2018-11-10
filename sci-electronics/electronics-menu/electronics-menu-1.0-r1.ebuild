# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit gnome2-utils

DESCRIPTION="Creates an \"Electronics\" desktop menu"
HOMEPAGE="http://www.gpleda.org/"
SRC_URI="http://geda.seul.org/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 sparc x86 ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake DESTDIR="${ED}" install
	dodoc README
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
