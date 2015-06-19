# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/fitsverify/fitsverify-4.17.ebuild,v 1.1 2014/03/27 04:48:19 bicatali Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="FITS file format checker"
HOMEPAGE="http://heasarc.gsfc.nasa.gov/docs/software/ftools/fitsverify/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=sci-libs/cfitsio-3:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}"

src_compile() {
	$(tc-getCC) -DSTANDALONE ${CFLAGS} ${LDFLAGS} \
		$($(tc-getPKG_CONFIG) --cflags cfitsio) \
		ftverify.c fvrf*.c \
		$($(tc-getPKG_CONFIG) --libs cfitsio) -o ${PN} \
		|| die "compiled failed"
}

src_install() {
	dobin fitsverify
	dodoc README
}
