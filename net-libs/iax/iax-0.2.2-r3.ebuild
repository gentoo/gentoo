# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils

DESCRIPTION="IAX (Inter Asterisk eXchange) Library"
HOMEPAGE="http://www.asterisk.org/"
SRC_URI="http://downloads.asterisk.org/pub/telephony/libiax/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug snomhack"

src_prepare() {
	epatch "${FILESDIR}/${PV}-debug.patch"
	epatch "${FILESDIR}/${PV}-memset.patch"
	epatch "${FILESDIR}/${PV}-sandbox.patch"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug extreme-debug) \
		$(use_enable snomhack)
}

src_install () {
	default
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
