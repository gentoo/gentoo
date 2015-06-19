# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/qtweb/qtweb-3.8.5_p108.ebuild,v 1.7 2014/06/19 01:26:24 jer Exp $

EAPI=5
inherit qt4-r2

MY_PN=QtWeb

DESCRIPTION="Lightweight, fast, secure and portable browser for the Web"
HOMEPAGE="http://www.qtweb.net/ https://github.com/magist3r/QtWeb"
SRC_URI="https://codeload.github.com/magist3r/${MY_PN}/tar.gz/b${PV/*_p} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4
"
DEPEND="
	${RDEPEND}
	dev-qt/designer:4
"

S=${WORKDIR}/${MY_PN}-b${PV/*_p}

src_install() {
	dobin build/${MY_PN}
}
