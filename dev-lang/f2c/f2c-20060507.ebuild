# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils toolchain-funcs

DESCRIPTION="Fortran to C converter"
HOMEPAGE="http://www.netlib.org/f2c"
#SRC_URI="ftp://netlib.bell-labs.com/netlib/f2c/src.tar"
# To create, download src.tar, ungzip everything inside, then tar.bz2 the whole
# thing.
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

RDEPEND="dev-libs/libf2c"
DEPEND="${RDEPEND}"

S="${WORKDIR}/src"

src_compile() {
	emake \
		-f makefile.u \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS}" \
		|| die "make failed"
}

src_install() {
	mv -f f2c.1t f2c.1
	doman f2c.1
	dobin f2c
	dodoc README Notice
}
