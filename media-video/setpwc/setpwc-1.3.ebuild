# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Control various aspects of Philips (and compatible) webcams"
HOMEPAGE="http://www.vanheusden.com/setpwc/"
SRC_URI="http://www.vanheusden.com/setpwc/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"

DEPEND="sys-kernel/linux-headers"

PATCHES=( "${FILESDIR}"/${P}-fix-build-system.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin setpwc
	dodoc readme.txt
	doman setpwc.1
}
