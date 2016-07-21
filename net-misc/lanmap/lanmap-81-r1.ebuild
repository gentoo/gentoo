# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils toolchain-funcs

DESCRIPTION="lanmap sits quietly on a network and builds a picture of what it sees"
HOMEPAGE="http://www.parseerror.com/lanmap"
SRC_URI="http://www.parseerror.com/${PN}/rev/${PN}-2006-03-07-rev${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~arm-linux ~x86-linux"

CDEPEND="net-libs/libpcap"
RDEPEND="
	${CDEPEND}
	media-gfx/graphviz
"
DEPEND="
	${CDEPEND}
	app-arch/unzip
"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-make.patch
	rm configure || die
	eautoreconf
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake prefix="${ED}"/usr install
	dodoc README.txt TODO.txt
}
