# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/log4shib/log4shib-1.0.1.ebuild,v 1.2 2013/03/07 12:05:14 pinkbyte Exp $

inherit eutils autotools

DESCRIPTION="Internet2 version for OpenSAML of log4cpp logging framework"
HOMEPAGE="https://wiki.shibboleth.net/confluence/display/OpenSAML/log4shib"
SRC_URI="http://shibboleth.internet2.edu/downloads/${PN}/${PV}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	# fix sandbox violation by doc installation
	epatch "${FILESDIR}/${PN}-doc.patch"
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	econf --without-idsa \
		$(use_enable doc doxygen)
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS || die "dodoc failed"
}
