# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Program for printing music scores"
HOMEPAGE="http://www.arkkra.com/"
SRC_URI="http://www.arkkra.com/ftp/pub/unix/mup${PV//.}src.tar.gz
	ftp://ftp.arkkra.com/pub/unix/mup${PV//.}src.tar.gz"

LICENSE="Arkkra"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	x11-libs/libX11
	x11-libs/libXext
	>=x11-libs/fltk-1.3:1
	x11-libs/libXpm
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	app-text/ghostscript-gpl
	media-libs/netpbm
	sys-apps/groff
	app-alternatives/yacc
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.9-build-system.patch
)

src_prepare() {
	default

	eautoreconf
}

src_compile() {
	emake -j1 CCOMPILER="$(tc-getCC)" CPPCOMPILER="$(tc-getCXX)" CFLAGS="${CFLAGS}"
}

src_install() {
	emake -j1 DESTDIR="${D}" install

	dodoc README
}
