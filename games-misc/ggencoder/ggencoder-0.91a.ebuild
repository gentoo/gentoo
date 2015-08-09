# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils qt4-r2

DESCRIPTION="Utility to encode and decode Game Genie (tm) codes"
HOMEPAGE="http://games.technoplaza.net/ggencoder/qt/"
SRC_URI="http://games.technoplaza.net/ggencoder/qt/history/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4"

S=${WORKDIR}/${P}/source

src_install() {
	dobin ${PN}
	dodoc ../docs/ggencoder.txt
	if use doc ; then
		dohtml -r ../apidocs/html/*
	fi
}
