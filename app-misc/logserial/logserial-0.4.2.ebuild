# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/logserial/logserial-0.4.2.ebuild,v 1.7 2014/08/10 18:06:37 slyfox Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="A tool for logging raw data from a serial device"
HOMEPAGE="http://www.gtlib.cc.gatech.edu/pub/Linux/system/serial/logserial-0.4.2.lsm"
SRC_URI="http://www.gtlib.cc.gatech.edu/pub/Linux/system/serial/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	tc-export CC
	emake || die "emake failed"
}

src_install() {
	dobin logserial || die "dobin failed"
	dodoc CHANGELOG README
}
