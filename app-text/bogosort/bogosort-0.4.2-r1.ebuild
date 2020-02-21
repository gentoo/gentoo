# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="A file sorting program which uses the bogosort algorithm"
HOMEPAGE="http://www.lysator.liu.se/~qha/bogosort/"
SRC_URI="ftp://ulrik.haugen.se/pub/unix/bogosort/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~mips ppc sparc x86 ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch \
		"${FILESDIR}"/xmalloc.patch \
		"${FILESDIR}"/${P}-glibc-2.10.patch
}

src_configure() {
	tc-export CC
	econf
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README NEWS ChangeLog AUTHORS
}
