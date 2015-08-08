# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils qt4-r2 games

MY_P="${PN}-src-${PV}"
DESCRIPTION="turn-based strategy game project"
HOMEPAGE="http://www.attal-thegame.org/"
SRC_URI="mirror://sourceforge/attal/${MY_P}.tar.bz2
	mirror://sourceforge/attal/themes-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND="dev-qt/qtgui:4
	dev-qt/qtsql:4
	dev-qt/qt3support:4
	media-libs/libsdl
	media-libs/sdl-mixer[vorbis]"

S=${WORKDIR}/${MY_P}

src_prepare() {
	mv ../themes .
	ecvs_clean
	epatch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-gentoo.patch
	sed -i \
		-e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		libCommon/displayHelp.cpp \
		libCommon/attalCommon.cpp \
		server/duel.cpp \
		|| die "sed failed"
}

src_configure() {
	eqmake4 Makefile.pro
}

src_compile() {
	local d

	for d in Common Client Fight Server
	do
		emake sub-lib$d || die "emake failed"
	done
	emake || die "emake failed"
}

src_install() {
	dogamesbin attal-* || die "dogamesbin failed"
	dogameslib.so lib*.so* || die "dogameslib.so failed"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r themes HOWTOPLAY.html || die "doins failed"
	dodoc AUTHORS NEWS README TODO
	prepgamesdirs
}
