# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Verifies the integrity of PNG, JNG and MNG files with internal checksums"
HOMEPAGE="http://www.libpng.org/pub/png/apps/pngcheck.html"
SRC_URI="mirror://sourceforge/png-mng/${P}.tar.gz"

LICENSE="HPND GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

src_compile() {
	emake -f Makefile.unx \
		CC="$(tc-getCC)" \
		CFLAGS="${LDFLAGS} ${CFLAGS} -DUSE_ZLIB" \
		ZLIB="-lz"
}

src_install() {
	dobin png{check,split,-fix-IDAT-windowsize}
	einstalldocs
}
