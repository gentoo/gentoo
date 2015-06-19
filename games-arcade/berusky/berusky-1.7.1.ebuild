# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/berusky/berusky-1.7.1.ebuild,v 1.3 2015/04/19 10:06:38 ago Exp $

EAPI=5
inherit autotools eutils gnome2-utils games

DATAFILE=${PN}-data-1.7
DESCRIPTION="free logic game based on an ancient puzzle named Sokoban"
HOMEPAGE="http://anakreon.cz/?q=node/1"
SRC_URI="http://www.anakreon.cz/download/${P}.tar.gz
	http://www.anakreon.cz/download/${DATAFILE}.tar.gz
	http://dev.gentoo.org/~hasufell/distfiles/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/libsdl[X,video]
	media-libs/sdl-image[png]
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	mv ../${DATAFILE}/{berusky.ini,GameData,Graphics,Levels} . || die
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -i \
		-e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		-e "s:@GENTOO_BINDIR@:${GAMES_BINDIR}:" \
		src/defines.h berusky.ini \
		|| die
	sed -i \
		-e "/AC_INIT/s/configure.in/${PN}, ${PV}/" \
		configure.in || die
	mv configure.in configure.ac || die
	eautoreconf
}

src_install() {
	default
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r berusky.ini GameData Graphics Levels
	doicon -s 32 "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN}
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
