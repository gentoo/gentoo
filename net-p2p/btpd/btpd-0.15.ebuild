# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="BitTorrent client consisting of a daemon and client"
HOMEPAGE="http://www.murmeldjur.se/btpd/"
SRC_URI="http://www.murmeldjur.se/btpd/${P}.tar.gz http://people.su.se/~rnyberg/btpd/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-misc/curl
		dev-libs/openssl"
DEPEND="${RDEPEND}"

# for the init.d script; this should probably be fixed not to require
# this so that it can work on G/FBSD too.
RDEPEND="${RDEPEND}
	virtual/shadow"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	newinitd "${FILESDIR}/initd_btpd" btpd || die
	newconfd "${FILESDIR}/confd_btpd" btpd || die

	dodoc CHANGES COPYRIGHT README || die
}
