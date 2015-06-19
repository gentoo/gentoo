# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/cobex/cobex-0.2.13.ebuild,v 1.4 2008/05/02 13:27:26 maekke Exp $

inherit eutils

DESCRIPTION="small implementation of Obex for phones using the DCU-11 USB-to-serial adapter"
HOMEPAGE="http://cobex.sourceforge.net/"
SRC_URI="mirror://sourceforge/cobex/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-libs/libezV24
	dev-libs/expat"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
	local f
	for f in get ls mkdir put rm ; do mv ${f}.c cobex_${f}.c || die ; done
}

src_install() {
	dobin cobex_{ls,mkdir,put,rm} || die
	dodoc Changelog README Things_to_know_T310.txt
}
