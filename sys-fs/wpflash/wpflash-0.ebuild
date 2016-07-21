# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="flash the firmware on a Webpal"
HOMEPAGE="http://webpal.bigbrd.com/"
SRC_URI="http://webpal.bigbrd.com/wpflash.c"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}"/${A} "${WORKDIR}"/ || die
	epatch "${FILESDIR}"/${PN}-gentoo.patch
}

src_compile() {
	emake wpflash || die
}

src_install() {
	dosbin wpflash || die
}
