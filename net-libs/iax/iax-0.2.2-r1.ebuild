# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/iax/iax-0.2.2-r1.ebuild,v 1.3 2010/11/04 17:32:53 fauli Exp $

EAPI="2"

DESCRIPTION="IAX (Inter Asterisk eXchange) Library"
HOMEPAGE="http://www.asterisk.org/"
SRC_URI="http://downloads.asterisk.org/pub/telephony/libiax/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="debug snomhack"

src_prepare() {
	if ! use debug; then
		sed -i -e "s:-DDEBUG_SUPPORT -DDEBUG_DEFAULT ::" src/Makefile.in \
			|| die "sed failed"
	fi

	# use users CFLAGS and LDFLAGS
	sed -i -e "s:CFLAGS =:CFLAGS+=:" src/Makefile.in || die "sed failed"
	sed -i -e "s:\(libiax_la_LDFLAGS = \):\1@LDFLAGS@:" src/Makefile.in \
		|| die "sed failed"

	# fix sandbox violations
	sed -i -e "s:\(\$(includedir)/iax\):\$(DESTDIR)\1:" src/Makefile.in \
		|| die "sed failed"
	sed -ie -e "/\/sbin\/ldconfig/d" src/Makefile.in || die "sed failed"
}

src_configure() {
	econf \
		$(use_enable debug extreme-debug) \
		$(use_enable snomhack)
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
