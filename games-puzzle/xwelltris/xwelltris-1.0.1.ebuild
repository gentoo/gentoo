# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/xwelltris/xwelltris-1.0.1.ebuild,v 1.16 2015/01/06 19:17:09 mr_bones_ Exp $

EAPI=5
inherit games

DESCRIPTION="2.5D tetris like game"
HOMEPAGE="http://xnc.jinr.ru/xwelltris/"
SRC_URI="http://xnc.jinr.ru/xwelltris/src/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-image[gif]"

src_prepare() {
	sed -i \
		-e '/INSTALL_PROGRAM/s/-s //' \
		src/Make.common.in || die
	sed -i \
		-e "/GLOBAL_SEARCH/s:\".*\":\"${GAMES_DATADIR}/${PN}\":" \
		src/include/globals.h.in || die
}

src_configure() {
	# configure/build process is pretty messed up
	egamesconf --with-sdl
}

src_compile() {
	emake -C src
}

src_install() {
	dodir "${GAMES_BINDIR}" "${GAMES_DATADIR}/${PN}" /usr/share/man
	emake install \
		INSTDIR="${D}/${GAMES_BINDIR}" \
		INSTLIB="${D}/${GAMES_DATADIR}/${PN}" \
		INSTMAN=/usr/share/man
	dodoc AUTHORS Changelog README*
	prepgamesdirs
}
