# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A usenet binary autoposter for unix"
HOMEPAGE="http://newspost.unixcab.org/"
SRC_URI="http://newspost.unixcab.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

src_prepare() {
	# Should fix some problems with unexpected server replies, cf. bug 185468
	epatch "${FILESDIR}"/${P}-nntp.patch
	epatch "${FILESDIR}"/CAN-2005-0101.patch
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch

	sed -e "/-strip newspost/d" -i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" LIBS="${LDFLAGS}" main
}

src_install () {
	dobin newspost
	doman man/man1/newspost.1
	dodoc CHANGES README
}
