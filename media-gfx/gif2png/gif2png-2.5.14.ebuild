# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Converts images from gif format to png format"
HOMEPAGE="http://catb.org/~esr/gif2png/"
SRC_URI="http://catb.org/~esr/${PN}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND=">=media-libs/libpng-1.2:0=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"

src_prepare() {
	default

	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install
}
