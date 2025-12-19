# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="Friendly GUI version of xmahjongg"
HOMEPAGE="https://www.lcdf.org/xmahjongg/"
SRC_URI="https://www.lcdf.org/xmahjongg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-libs/libXt"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-drop-register-keyword.patch
)

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
