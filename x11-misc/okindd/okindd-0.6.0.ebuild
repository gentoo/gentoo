# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit qt4-r2

MY_P="${P}-49-20110113"

DESCRIPTION="On Screen Display (OSD) for KDE 4.x - works on any qt desktop"
HOMEPAGE="http://sites.kochkin.org/okindd/Home"
SRC_URI="http://sites.kochkin.org/okindd/Home/development/${MY_P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"

DEPEND="dev-qt/qtgui:4
	dev-qt/qtdbus:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_configure() {
	eqmake4 okindd.pro
}

DOCS=( changelog )
src_install() {
	qt4-r2_src_install
	docinto examples
	dodoc scripts/*
	dodoc conf/okinddrc.example

	elog "You can find an example configuration file at"
	elog "	/usr/share/doc/okindd/examples/okinddrc.example"
	elog "It should be placed in \${HOME}/.okindd/"
}
