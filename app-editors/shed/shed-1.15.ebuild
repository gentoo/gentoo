# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="Simple Hex EDitor"
HOMEPAGE="http://shed.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-interix.patch
	"${FILESDIR}"/${P}-tinfo.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}
