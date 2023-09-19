# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="friendly GUI version of xmahjongg"
HOMEPAGE="http://www.lcdf.org/xmahjongg/"
SRC_URI="http://www.lcdf.org/xmahjongg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-libs/libXt"

PATCHES=( "${FILESDIR}"/${P}-autotools.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default

	newicon share/tiles/small.gif ${PN}.gif
	make_desktop_entry xmahjongg "Xmahjongg" /usr/share/pixmaps/${PN}.gif
}
