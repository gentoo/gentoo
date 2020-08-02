# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Non-intrusive utility for estimation of available bandwidth of Internet paths"
HOMEPAGE="https://www.cc.gatech.edu/fac/constantinos.dovrolis/bw-est/pathload.html"
SRC_URI="https://dev.gentoo.org/~jer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${PN}_${PV}
PATCHES=(
	"${FILESDIR}"/${PN}-1.3.2-make.patch
)

src_configure() {
	tc-export CC
	default
}

src_install() {
	dobin ${PN}_snd ${PN}_rcv
	dodoc CHANGELOG CHANGES README
}
