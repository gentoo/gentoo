# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/thrulay/thrulay-0.9-r1.ebuild,v 1.5 2014/08/10 21:00:52 slyfox Exp $

EAPI=4
inherit toolchain-funcs autotools

DESCRIPTION="Measure the capacity of a network by sending a bulk TCP stream over it"
HOMEPAGE="http://www.internet2.edu/~shalunov/thrulay/"
SRC_URI="http://www.internet2.edu/~shalunov/thrulay/${P}.tar.gz
		mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
DEPEND=""

src_prepare() {
	echo 'thrulay thrulayd: libthrulay.la' >>src/Makefile.am
	eautoreconf
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	#dobin src/thrulay || die "dobin failed"
	#dosbin src/thrulayd || die "dosbin failed"
	dodoc LICENSE README TODO doc/thrulay-protocol.txt || die "dodoc failed"
	doman doc/thrulay*.[1-8] || die "doman failed"
	newinitd "${FILESDIR}"/thrulayd-init.d thrulayd || die "newinitd failed"
	newconfd "${FILESDIR}"/thrulayd-conf.d thrulayd || die "newconfd failed"
}
