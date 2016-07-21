# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Zorro bus utility for Amigas running 2.1 and later kernels"
HOMEPAGE="http://users.telenet.be/geertu/Download/#zorro"
SRC_URI="http://users.telenet.be/geertu/Download/${P}.tar.gz"
IUSE=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="m68k ~ppc"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${PN}-0.04-20021014.diff
	epatch "${FILESDIR}"/${PN}-gentoo.diff
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die
}

src_install() {
	dosbin lszorro
	doman *.8

	insinto /usr/share/misc
	doins zorro.ids
}
