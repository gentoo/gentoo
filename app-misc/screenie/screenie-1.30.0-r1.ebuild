# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/screenie/screenie-1.30.0-r1.ebuild,v 1.6 2009/06/10 19:03:42 maekke Exp $

EAPI="2"

inherit eutils

DESCRIPTION="screen(1) frontend that is designed to be a session handler"
HOMEPAGE="http://pubwww.hsz-t.ch/~mgloor/screenie.html"
SRC_URI="http://pubwww.hsz-t.ch/~mgloor/data/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ia64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="app-misc/screen"

src_prepare() {
	epatch "${FILESDIR}/${PN}-CVE-2008-5371.patch"
}

src_install() {
	dobin screenie || die "dobin failed"
	dodoc AUTHORS ChangeLog INSTALL README TODO || die "dodoc failed"
}
