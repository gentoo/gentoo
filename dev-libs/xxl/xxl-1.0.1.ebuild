# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xxl/xxl-1.0.1.ebuild,v 1.5 2010/01/15 19:50:02 ulm Exp $

inherit eutils

DESCRIPTION="C/C++ library that provides exception handling and asset management"
HOMEPAGE="http://www.zork.org/xxl/"
SRC_URI="http://www.zork.org/software/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-nested-exception.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README
}
