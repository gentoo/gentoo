# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Verifies the integrity of PNG, JNG, and MNG files with internal checksums"
HOMEPAGE="http://www.libpng.org/pub/png/apps/pngcheck.html"
SRC_URI="http://www.libpng.org/pub/png/src/${P}.tar.gz"

LICENSE="HPND GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

src_compile() {
	emake -f Makefile.unx \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		CFLAGS="${CFLAGS} ${LDFLAGS} -DUSE_ZLIB" \
		ZLIB="-lz"
}

src_install() {
	dobin png{check,split,-fix-IDAT-windowsize}
	doman pngcheck.1 gpl/pngsplit.1

	einstalldocs
}
