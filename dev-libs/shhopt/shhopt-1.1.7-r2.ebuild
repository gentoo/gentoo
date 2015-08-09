# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="library for parsing command line options"
HOMEPAGE="http://shh.thathost.com/pub-unix/"
SRC_URI="http://shh.thathost.com/pub-unix/files/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
}

src_compile() {
	emake CC=$(tc-getCC) || die
}

src_install() {
	dolib.a libshhopt.a || die
	ln -s libshhopt.so.${PV} libshhopt.so
	ln -s libshhopt.so.${PV} libshhopt.so.${PV:0:1}
	dolib.so libshhopt.so* || die
	insinto /usr/include
	doins shhopt.h
	dodoc ChangeLog CREDITS INSTALL README TODO
}
