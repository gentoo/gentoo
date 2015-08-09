# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit autotools

MY_P=${P/mars/mars-src}

DESCRIPTION="Multicore Application Runtime System"
HOMEPAGE="ftp://ftp.infradead.org/pub/Sony-PS3/mars/"
SRC_URI="ftp://ftp.infradead.org/pub/Sony-PS3/mars/1.0.1/${MY_P}.tar.gz"

LICENSE="MIT_Plus MIT"
SLOT="0"
KEYWORDS="~ppc64"
IUSE=""

DEPEND="sys-libs/libspe2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/core"

src_unpack () {
	unpack ${A}
	cd "${S}"
	# repeat after me: "dummy tuples are bogus"
	sed -i -e "s:/spu:/spu-elf:" \
		   -e "s:--host=spu:--host=spu-elf:" configure.ac
	eautoreconf
}

src_compile () {
	unset CFLAGS
	unset CXXFLAGS
	unset CFLAGS_ppc64
	econf --with-mars-platform=cell || die
	emake || die
}

src_install () {
	emake -j1 DESTDIR="${D}" install
}
