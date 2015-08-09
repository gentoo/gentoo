# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
