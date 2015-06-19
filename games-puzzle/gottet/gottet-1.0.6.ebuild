# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/gottet/gottet-1.0.6.ebuild,v 1.3 2015/02/25 15:48:17 ago Exp $

EAPI=5

LANGS="ca de en es fr he ko ms pl ro ru tr vi"
inherit eutils qt4-r2 games

DESCRIPTION="A tetris clone based on Qt4"
HOMEPAGE="http://gottcode.org/gottet/"
SRC_URI="http://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -i -e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}:" \
		src/locale_dialog.cpp \
		|| die "sed failed"
}

src_configure() {
	qt4-r2_src_configure
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}/translations/
	for lang in ${LINGUAS};do
		for x in ${LANGS};do
			if [[ ${lang} == ${x} ]];then
				doins translations/${PN}_${x}.qm
			fi
		done
	done
	insinto /usr/share/icons
	doins -r icons/hicolor
	dodoc CREDITS ChangeLog NEWS README
	doicon icons/${PN}.xpm
	domenu icons/${PN}.desktop
	prepgamesdirs
}
