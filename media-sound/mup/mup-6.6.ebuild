# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Program for printing music scores"
HOMEPAGE="http://www.arkkra.com/"
SRC_URI="ftp://ftp.arkkra.com/pub/unix/mup${PV//.}src.tar.gz"

LICENSE="Arkkra"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	>=x11-libs/fltk-1.3:1
	x11-libs/libXpm
	virtual/jpeg:0
	media-libs/libpng:0="
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_prepare() {
	default
	sed -i -e "s:/lib:/$(get_libdir):g" makefile || die
}

src_compile() {
	emake CCOMPILER="$(tc-getCC)" CPPCOMPILER="$(tc-getCXX)" CFLAGS="${CFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc docs/{*.txt,README0}
	docinto html
	dodoc docs/{*.html,uguide/*}
	docinto sample
	dodoc docs/{*.mup,*.ps}
}
