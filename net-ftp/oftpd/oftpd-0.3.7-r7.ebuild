# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit autotools eutils

DESCRIPTION="Secure, small, anonymous only ftpd"
HOMEPAGE="http://www.time-travellers.org/oftpd"
SRC_URI="http://www.time-travellers.org/oftpd/${P}.tar.gz
	ftp://ftp.deepspace6.net/pub/ds6/sources/${PN}/${PN}-0.3.6-ipv6rel2.patch.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 sh sparc x86"
IUSE="ipv6"

DEPEND="net-ftp/ftpbase"
RDEPEND="${DEPEND}"

src_prepare() {
	cd "${WORKDIR}" || die
	epatch "${FILESDIR}"/oftpd-0.3.7-ipv6rel2-0.3.6-to-0.3.7.patch

	cd "${S}" || die
	epatch "${WORKDIR}"/${PN}-0.3.6-ipv6rel2.patch

	# Don't crash when using an unsupported address family, #159178.
	# updated in bug #157005
	epatch "${FILESDIR}"/${P}-family-1.patch

	eautoreconf
}

src_configure() {
	econf --bindir=/usr/sbin $(use_enable ipv6)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS FAQ NEWS README TODO || die
	keepdir /home/ftp
	newinitd "${FILESDIR}"/init.d.oftpd-r7 oftpd || die
	newconfd "${FILESDIR}"/conf.d.oftpd-r7 oftpd || die
}
