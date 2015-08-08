# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Automates maintaining a web page or other FTP archive"
HOMEPAGE="http://weex.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="" #nls

DEPEND="sys-libs/ncurses"

src_prepare() {
	epatch "${FILESDIR}/${P}-va_list.patch"
	epatch "${FILESDIR}/formatstring.patch"
}

src_configure() {
	econf --disable-nls #532502
}

src_install() {
	default
	dodoc doc/TODO* doc/README* doc/FAQ* doc/sample* doc/ChangeLog* \
		doc/BUG* doc/THANK*
}
