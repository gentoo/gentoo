# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools desktop

DESCRIPTION="ZANAC type game"
HOMEPAGE="http://triring.net/ps2linux/games/kxl/kxlgames.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-games/KXL"
RDEPEND="${DEPEND}
	media-fonts/font-adobe-100dpi"

PATCHES=(
	"${FILESDIR}"/${P}-configure.in.patch
	"${FILESDIR}"/${P}-cflags.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	rm aclocal.m4 || die
	eautoreconf
}

src_install() {
	dodir /var/lib
	default

	newicon src/bmp/boss1.bmp ${PN}.bmp
	make_desktop_entry grande Grande /usr/share/pixmaps/${PN}.bmp
}
