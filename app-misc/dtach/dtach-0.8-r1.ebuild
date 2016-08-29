# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="Emulates the detach feature of screen"
HOMEPAGE="http://dtach.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~arm ppc x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-CVE-2012-3368.patch
}

src_install() {
	dobin dtach
	doman dtach.1
	dodoc README
}
