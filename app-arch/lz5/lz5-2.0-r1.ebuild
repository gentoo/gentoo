# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="An efficient compressor with very fast decompression"
HOMEPAGE="https://github.com/inikep/lz5"
SRC_URI="https://github.com/inikep/lz5/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 BSD-2"
SLOT="0/2"
KEYWORDS="~amd64"

src_prepare() {
	default
	sed -i -e 's/install: lz5$(EXT)/install:/' programs/Makefile || die
	sed -i -e 's/install: lib liblz5.pc/install:/' lib/Makefile || die
}

src_compile() {
	emake -C lib CC="$(tc-getCC)" lib liblz5.pc
	emake -C programs CC="$(tc-getCC)" lz5
}

src_install() {
	emake install DESTDIR="${ED}" PREFIX="/usr" LIBDIR="/usr/$(get_libdir)"
	rm "${ED}"/usr/$(get_libdir)/liblz5.a || die

	einstalldocs
}
