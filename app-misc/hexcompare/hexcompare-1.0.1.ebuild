# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
