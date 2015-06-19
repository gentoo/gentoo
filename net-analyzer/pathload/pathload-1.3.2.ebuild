# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/pathload/pathload-1.3.2.ebuild,v 1.3 2014/07/16 17:59:33 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Non-intrusive utility for estimation of available bandwidth of Internet paths"
HOMEPAGE="http://www.cc.gatech.edu/fac/constantinos.dovrolis/bw-est/pathload.html"
SRC_URI="https://dev.gentoo.org/~jer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${PN}_${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-make.patch
	tc-export CC
}

src_install() {
	dobin ${PN}_snd ${PN}_rcv
	dodoc CHANGELOG CHANGES README
}
