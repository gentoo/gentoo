# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/dtach/dtach-0.8-r1.ebuild,v 1.5 2012/11/15 12:18:14 blueness Exp $

EAPI=4

inherit eutils

DESCRIPTION="Emulates the detach feature of screen"
HOMEPAGE="http://dtach.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm ppc x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-CVE-2012-3368.patch
}

src_install() {
	dobin dtach
	doman dtach.1
	dodoc README
}
