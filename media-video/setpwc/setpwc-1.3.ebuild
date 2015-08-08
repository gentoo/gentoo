# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit toolchain-funcs

DESCRIPTION="Control various aspects of Philips (and compatible) webcams"
HOMEPAGE="http://www.vanheusden.com/setpwc/"
SRC_URI="http://www.vanheusden.com/setpwc/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE=""

RDEPEND=""
DEPEND="sys-kernel/linux-headers"

src_prepare() {
	sed -i -e '/CFLAGS/s: -O2::' Makefile || die
}

src_compile() {
	tc-export CC
	emake LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin setpwc
	dodoc readme.txt
	doman setpwc.1
}
