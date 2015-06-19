# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnrd/dnrd-2.20.3-r1.ebuild,v 1.2 2012/06/14 02:05:55 zmedico Exp $

inherit autotools eutils user

DESCRIPTION="A caching DNS proxy server"
HOMEPAGE="http://dnrd.sourceforge.net/"
SRC_URI="mirror://sourceforge/dnrd/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"
DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-docdir.patch
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable debug) \
		--disable-dependency-tracking \
		--docdir=/usr/share/doc/${PF} \
		|| die

	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	keepdir /etc/dnrd
	doinitd ${FILESDIR}/dnrd
	newconfd ${FILESDIR}/dnrd.conf dnrd
}

pkg_postinst() {
	enewgroup dnrd
	enewuser dnrd -1 -1 /dev/null dnrd
}
