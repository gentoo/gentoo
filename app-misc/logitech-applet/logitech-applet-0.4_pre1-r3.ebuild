# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/logitech-applet/logitech-applet-0.4_pre1-r3.ebuild,v 1.5 2014/07/21 13:54:37 ssuominen Exp $

EAPI=5
inherit eutils

MY_P=${P/_pre/test}
MY_P=${MY_P/-applet/_applet}

DESCRIPTION="Control utility for some special features of some special Logitech USB mice!"
HOMEPAGE="http://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="virtual/libusb:0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-mx300-mx518.patch
}

src_install() {
	dosbin logitech_applet
	dodoc AUTHORS ChangeLog README doc/article.txt

	docinto examples
	dodoc "${FILESDIR}"/40-logitech_applet.rules
}
