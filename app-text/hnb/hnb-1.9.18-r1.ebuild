# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/hnb/hnb-1.9.18-r1.ebuild,v 1.10 2014/12/14 13:25:17 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="A program to organize many kinds of data in one place"
HOMEPAGE="http://hnb.sourceforge.net/"
SRC_URI="http://hnb.sourceforge.net/.files/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="sys-libs/ncurses"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	rm -r ${P} || die
	rm src/cli_history.o || die

	epatch \
		"${FILESDIR}"/${P}-flags.patch \
		"${FILESDIR}"/${P}-include.patch \
		"${FILESDIR}"/${P}-printf.patch

	tc-export AR CC PKG_CONFIG

	# bug #532552
	export LC_ALL=C
}

src_install() {
	dodoc README doc/hnbrc
	doman doc/hnb.1
	dobin src/hnb
}
