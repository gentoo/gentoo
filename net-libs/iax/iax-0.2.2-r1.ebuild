# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="IAX (Inter Asterisk eXchange) Library"
HOMEPAGE="https://www.asterisk.org/"
SRC_URI="https://downloads.asterisk.org/pub/telephony/libiax/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="debug snomhack"

src_prepare() {
	default
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
