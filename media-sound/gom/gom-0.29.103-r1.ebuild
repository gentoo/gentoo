# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Console Mixer Program for OSS"
HOMEPAGE="http://www.fh-worms.de/~inf222"
SRC_URI="http://www.Fh-Worms.DE./~inf222/code/c/gom/released/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default
	rmdir examples/standard || die
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default

	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples
}
