# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop

DESCRIPTION="A simple block-pushing game"
HOMEPAGE="http://kenn.frap.net/wakkabox/"
SRC_URI="http://kenn.frap.net/wakkabox/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.0.1"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-gentoo.patch
	rm aclocal.m4
	eautoreconf
}

src_install() {
	default
	newicon bigblock.bmp ${PN}.bmp
	make_desktop_entry ${PN} "Wakkabox" /usr/share/pixmaps/${PN}.bmp
}
