# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

LANGS="ca cs de el en es et fr hu ms nl pl ro ru tr"
LANGSLONG="pt_BR"
inherit eutils qt4-r2 games

DESCRIPTION="A color matching game"
HOMEPAGE="http://gottcode.org/hexalate/"
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
	sed -i -e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${PN}:" \
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
