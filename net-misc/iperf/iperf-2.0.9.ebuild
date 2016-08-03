# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Tool to measure IP bandwidth using UDP or TCP"
HOMEPAGE="http://iperf2.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}2/${P}.tar.gz"

LICENSE="HPND"
SLOT="2"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint"
IUSE="ipv6 threads debug"

DOCS="INSTALL README"

src_configure() {
	econf \
		$(use_enable debug debuginfo) \
		$(use_enable ipv6) \
		$(use_enable threads)
}

src_install() {
	default
	dodoc doc/*
	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
