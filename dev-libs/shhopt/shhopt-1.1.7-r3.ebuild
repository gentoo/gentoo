# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="library for parsing command line options"
HOMEPAGE="https://shh.thathost.com/pub-unix/"
SRC_URI="https://shh.thathost.com/pub-unix/files/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=( "${FILESDIR}"/${P}-build.patch )

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dolib.a libshhopt.a
	ln -s libshhopt.so.${PV} libshhopt.so || die
	ln -s libshhopt.so.${PV} libshhopt.so.${PV:0:1} || die
	dolib.so libshhopt.so*
	doheader shhopt.h
	dodoc ChangeLog CREDITS README TODO
}
