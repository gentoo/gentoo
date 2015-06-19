# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/stan/stan-0.4.1.ebuild,v 1.8 2014/08/10 02:27:00 patrick Exp $

EAPI="2"
inherit autotools eutils

DESCRIPTION="Stan is a console application that analyzes binary streams and calculates statistical information"
HOMEPAGE="http://www.roqe.org/stan/"
SRC_URI="http://www.roqe.org/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}/${P}-errno.patch"
	sed -i -e "s/-O3/${CFLAGS}/" configure.in || die "sed failed"
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.in || die
	eautoreconf
}

src_install() {
	emake install DESTDIR="${D}" || die "install failed"
	dodoc README || die
}
