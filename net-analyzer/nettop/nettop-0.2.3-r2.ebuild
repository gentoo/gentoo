# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="top like program for network activity"
SRC_URI="http://srparish.net/scripts/${P}.tar.gz"
HOMEPAGE="http://srparish.net/software/"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 ~arm ppc x86"

DEPEND="
	sys-libs/slang
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc411.patch \
		"${FILESDIR}"/${P}-offbyone.patch
	tc-export CC
}

src_install() {
	dosbin nettop
	dodoc ChangeLog README THANKS
}
