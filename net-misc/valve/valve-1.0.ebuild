# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/valve/valve-1.0.ebuild,v 1.4 2010/03/24 22:11:58 robbat2 Exp $

DESCRIPTION="Copies data while enforcing a specified maximum transfer rate"
HOMEPAGE="http://www.fourmilab.ch/webtools/valve/"
SRC_URI="http://www.fourmilab.ch/webtools/valve/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="doc"

DEPEND=""

src_compile() {
	econf || die
	emake CTANGLE='' CWEAVE='' || die
}

src_install() {
	dobin valve || die
	doman valve.1 || die
	dodoc README valve.pdf || die
	dohtml index.html logo.png || die
}

src_test() {
	emake CTANGLE='' CWEAVE='' check || die "check failed"
}
