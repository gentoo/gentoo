# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libjwc_c/libjwc_c-1.1-r2.ebuild,v 1.4 2012/08/20 19:27:15 johu Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils

PATCH="612"

DESCRIPTION="additional c library for ccp4"
HOMEPAGE="http://www.ccp4.ac.uk/main.html"
SRC_URI="ftp://ftp.ccp4.ac.uk/jwc/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="static-libs"

DEPEND="sci-libs/ccp4-libs"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PATCH}-gentoo.patch )

src_prepare() {
	rm missing || die
	echo "libjwc_c_la_LIBADD = -lm -lccp4f" >> Makefile.am || die
	autotools-utils_src_prepare
}
