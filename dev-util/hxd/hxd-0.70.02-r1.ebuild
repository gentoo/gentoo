# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Binary to hexadecimal converter"
HOMEPAGE="http://www-tet.ee.tu-berlin.de/solyga/linux/"
SRC_URI="http://linux.xulin.de/c/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~sparc ~mips ~ppc"
IUSE=""

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-prll-flags.patch \
		"${FILESDIR}"/${P}-llong-redef.patch
	tc-export CC
}

src_install() {
	dobin hxd unhxd
	doman hxd.1 unhxd.1
	dodoc README TODO
}
