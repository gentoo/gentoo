# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools eutils flag-o-matic

MY_P="hfsplus_${PV}"
DESCRIPTION="HFS+ Filesystem Access Utilities (a PPC filesystem)"
HOMEPAGE="http://penguinppc.org/historical/hfsplus/"
SRC_URI="http://penguinppc.org/historical/hfsplus/${MY_P}.src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc ppc64 x86"
IUSE="static-libs"

DEPEND="app-arch/bzip2"
RDEPEND=""

S=${WORKDIR}/hfsplus-${PV}

src_prepare() {
	epatch "${FILESDIR}/${P}-glob.patch"
	epatch "${FILESDIR}/${P}-errno.patch"
	epatch "${FILESDIR}/${P}-gcc4.patch"
	epatch "${FILESDIR}/${P}-string.patch"
	epatch "${FILESDIR}/${P}-stdlib.patch"
	epatch "${FILESDIR}/${P}-cflags.patch"
	# let's avoid the Makefile.cvs since isn't working for us
	eautoreconf

	append-flags -fgnu89-inline
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}"/usr/ -name libhfsp.la -delete
	newman doc/man/hfsp.man hfsp.1
}
