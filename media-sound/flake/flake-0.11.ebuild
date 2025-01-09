# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="An alternative to the FLAC reference encoder"
HOMEPAGE="https://flake-enc.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/flake-enc/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=("${FILESDIR}"/${P}-make-instability.patch)

src_configure() {
	# NIH configure script
	./configure \
		--ar="$(tc-getAR)" \
		--cc="$(tc-getCC)" \
		--ranlib="$(tc-getRANLIB)" \
		--prefix="${EPREFIX}"/usr \
		--disable-opts \
		--disable-debug \
		--disable-strip || die "configure failed"
}

src_install() {
	dobin flake/flake
	doheader libflake/flake.h
	dolib.a libflake/libflake.a
	dodoc Changelog README
}
