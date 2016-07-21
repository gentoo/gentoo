# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils qt4-r2 games

DESCRIPTION="An ancient boardgame, very common in Japan, China and Korea"
HOMEPAGE="http://qgo.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/alsa-lib
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qttest:4"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e "/QGO_INSTALL_PATH/s:/usr/share:${GAMES_DATADIR}:" \
		-e "/QGO_INSTALL_BIN_PATH/s:/usr/bin:${GAMES_BINDIR}:" \
		-e 's:$(QTDIR)/bin/lrelease:lrelease:' \
		src/src.pro || die

	sed -i \
		-e "/TRANSLATIONS_PATH_PREFIX/s:/usr/share:${GAMES_DATADIR}:" \
		src/defines.h || die

	epatch \
		"${FILESDIR}"/${P}-gcc45.patch \
		"${FILESDIR}"/${P}-qt47.patch \
		"${FILESDIR}"/${P}-buffer.patch
}

src_configure() {
	eqmake4 qgo2.pro
}

src_install() {
	qt4-r2_src_install

	dodoc AUTHORS

	insinto "${GAMES_DATADIR}"/qgo/languages
	doins src/translations/*.qm

	prepgamesdirs
}
