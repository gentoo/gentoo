# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/fetch/fetch-1.0-r1.ebuild,v 1.5 2014/08/10 20:10:28 slyfox Exp $

DESCRIPTION="Fetch is a simple, fast, and flexible HTTP download tool built on the HTTP Fetcher library"
HOMEPAGE="http://sourceforge.net/projects/fetch/"
SRC_URI="mirror://sourceforge/fetch/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-libs/http-fetcher-1.0.1"
RDEPEND="${DEPEND}"

src_unpack(){
	unpack ${A}
	cd "${S}"
	sed -i -e "/^ld_rpath/d" configure || die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README INSTALL
	dohtml docs/*.html
}
