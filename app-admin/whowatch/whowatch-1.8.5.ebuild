# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

DESCRIPTION="Displays information about users currently logged on in real time"
HOMEPAGE="http://wizard.ae.krakow.pl/~mike/"
SRC_URI="http://wizard.ae.krakow.pl/~mike/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~mips ppc x86"
IUSE=""

RDEPEND="
	sys-libs/ncurses:0=
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.8.4-tinfo.patch
	epatch "${FILESDIR}"/${PN}-1.8.4-select.patch
	eautoreconf
}

src_install() {
	dobin src/${PN}
	doman ${PN}.1
	dodoc AUTHORS ChangeLog README TODO
}
