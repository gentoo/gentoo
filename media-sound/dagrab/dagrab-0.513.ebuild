# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/dagrab/dagrab-0.513.ebuild,v 1.4 2006/08/06 19:05:08 vapier Exp $

inherit eutils

MY_P="${PN}-S${PV}"
DESCRIPTION="fixed point cd ripper"
HOMEPAGE="http://vertigo.fme.vutbr.cz/~stibor/dagrab.html"
SRC_URI="http://ashtray.jz.gts.cz/~smsti/archiv/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-freedb.patch
}

src_install() {
	dobin dagrab || die
	dodoc BUGS CHANGES FAQ grab TODO
	doman dagrab.1
}
