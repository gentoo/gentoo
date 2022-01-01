# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

MY_P=${P/_beta/beta}

DESCRIPTION="tcptraceroute is a traceroute implementation using TCP packets"
HOMEPAGE="https://github.com/mct/tcptraceroute"
SRC_URI="https://codeload.github.com/mct/${PN}/tar.gz/${MY_P} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"

DEPEND="
	net-libs/libnet:1.1
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

# michael.toren.net is no longer available
RESTRICT="test"

S=${WORKDIR}/${PN}-${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-cross-compile-checks.patch
	eautoreconf
}

src_install() {
	dosbin tcptraceroute
	fowners root:wheel /usr/sbin/tcptraceroute
	fperms 4710 /usr/sbin/tcptraceroute
	doman tcptraceroute.1
	dodoc examples.txt README ChangeLog
	dohtml tcptraceroute.1.html
}
