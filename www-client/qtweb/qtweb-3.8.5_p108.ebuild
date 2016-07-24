# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt4-r2

MY_PN=QtWeb

DESCRIPTION="Lightweight, fast, secure and portable browser for the Web"
HOMEPAGE="http://www.qtweb.net/ https://github.com/magist3r/QtWeb"
SRC_URI="https://codeload.github.com/magist3r/${MY_PN}/tar.gz/b${PV/*_p} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

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
