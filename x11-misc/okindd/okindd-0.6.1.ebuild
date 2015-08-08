# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit qt4-r2

MY_P=${P}-23-20120304

DESCRIPTION="On Screen Display (OSD) for KDE 4.x - works on any Qt desktop"
HOMEPAGE="http://sites.kochkin.org/okindd/Home"
SRC_URI="http://sites.kochkin.org/okindd/Home/${MY_P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

DOCS="changelog"
PATCHES=( "${FILESDIR}/${P}-gcc-4.7.patch" )

src_install() {
	qt4-r2_src_install

	rm -rf "${ED}"usr/share/doc/${PN}
	docinto examples
	dodoc conf/okinddrc.{example,my} scripts/*
	docompress -x /usr/share/doc/${PF}/examples
}

pkg_postinst() {
	elog "You can find an example configuration file at"
	elog "    ${EROOT}usr/share/doc/${PF}/examples/okinddrc.example"
	elog "It should be placed inside \${HOME}/.okindd/"
}
