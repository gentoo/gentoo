# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/psmark/psmark-2.1.ebuild,v 1.5 2015/01/15 14:21:17 mrueg Exp $

EAPI=5

inherit eutils toolchain-funcs

MY_PN=${PN}-v
MY_P=${MY_PN}${PV}
S=${WORKDIR}/${PN}

DESCRIPTION="Prints watermark-like text on any PostScript document"
HOMEPAGE="http://www.antitachyon.com/Content/10_Produkte/50_Utilities/psmark/"
SRC_URI="http://www.antitachyon.com/download/${MY_P}.tar.gz"

IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	epatch "${FILESDIR}"/${P}-string.patch\
		"${FILESDIR}"/${P}-Makefile-QA.patch
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin psmark
	doman psmark.1
	dodoc README CHANGELOG
}
