# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools

MY_PV=${PV/_/}

DESCRIPTION="A traceroute-like utility that sends packets based on protocol"
HOMEPAGE="http://traceproto.sourceforge.net/"
SRC_URI="mirror://gentoo/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="debug"

RDEPEND="
	net-libs/libnet:1.1
	net-libs/libpcap
	sys-libs/ncurses
	debug? ( dev-libs/dmalloc )
"
DEPEND="
	${RDEPEND}
	app-doc/doxygen[dot]
	virtual/pkgconfig
"

S=${WORKDIR}/${PN}-${MY_PV}

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	epatch "${FILESDIR}"/${P}-tinfo.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable debug dmalloc)
}
