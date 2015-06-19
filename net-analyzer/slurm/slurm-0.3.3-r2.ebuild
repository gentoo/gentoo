# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/slurm/slurm-0.3.3-r2.ebuild,v 1.3 2015/01/26 10:15:48 ago Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="Realtime network interface monitor based on FreeBSD's pppstatus"
HOMEPAGE="http://www.wormulon.net/projects/slurm"
SRC_URI="http://www.wormulon.net/files/code/slurm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

RDEPEND="sys-libs/ncurses"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-overflow.patch \
		"${FILESDIR}"/${P}-theme.patch
	eautoreconf
}

src_install() {
	dobin slurm

	insinto /usr/share/${PN}
	doins themes/*.theme

	doman slurm.1
	dodoc AUTHORS ChangeLog FAQ KEYS README THANKS THEMES.txt TODO
}
