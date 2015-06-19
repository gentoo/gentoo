# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/hexcompare/hexcompare-1.0.1.ebuild,v 1.1 2010/11/10 23:01:05 xmw Exp $

EAPI=3

inherit eutils toolchain-funcs versionator

DESCRIPTION="ncurses-based visual comparison of binary files"
HOMEPAGE="http://hexcompare.sourceforge.net/"
MY_P=${PN}-$(replace_all_version_separators '')
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
}

src_compile() {
	$(tc-getCC) \
		${CFLAGS} $(/usr/bin/ncurses5-config --cflags) \
		-o ${PN} main.c gui.c \
		${LDFLAGS} $(/usr/bin/ncurses5-config --libs) || die
}

src_install() {
	dobin ${PN} || die
	dodoc README || die
}
