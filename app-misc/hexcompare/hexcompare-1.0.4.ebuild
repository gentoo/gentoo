# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/hexcompare/hexcompare-1.0.4.ebuild,v 1.1 2015/06/09 18:02:44 xmw Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="ncurses-based visual comparison of binary files"
HOMEPAGE="http://hexcompare.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/ncurses:5"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch
	tc-export CC
}

src_install() {
	dobin ${PN}
	dodoc README
}
