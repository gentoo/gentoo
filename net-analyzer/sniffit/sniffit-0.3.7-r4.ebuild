# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/sniffit/sniffit-0.3.7-r4.ebuild,v 1.6 2014/07/17 02:15:28 jer Exp $

EAPI=5
inherit autotools eutils toolchain-funcs

MY_P="${P/-/.}.beta"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Interactive Packet Sniffer"
SRC_URI="http://reptile.rug.ac.be/~coder/${PN}/files/${MY_P}.tar.gz"
HOMEPAGE="http://reptile.rug.ac.be/~coder/sniffit/sniffit.html"

RDEPEND="
	net-libs/libpcap
	>=sys-libs/ncurses-5.2
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 ppc sparc x86"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-misc.patch \
		"${FILESDIR}"/${P}-tinfo.patch
	eautoreconf
	tc-export CC
}

src_install () {
	dosbin sniffit

	doman sniffit.5 sniffit.8
	dodoc README* PLUGIN-HOWTO BETA* HISTORY
}
