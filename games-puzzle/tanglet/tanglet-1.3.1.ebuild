# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
LANGS="cs de es en fr he hu it nl ro tr uk"
LANGSLONG="es_CL"
inherit eutils gnome2-utils qmake-utils games

DESCRIPTION="A single player word finding game based on Boggle"
HOMEPAGE="http://gottcode.org/tanglet/"
SRC_URI="http://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/zlib
	dev-qt/qtcore:5
	dev-qt/qtgui:5"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-datadir.patch
	sed -i \
		-e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		src/locale_dialog.cpp \
		src/main.cpp || die
}

src_configure() {
	eqmake5 tanglet.pro
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data
	#translations
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

	dodoc ChangeLog CREDITS NEWS

	doicon icons/${PN}.xpm
	domenu icons/${PN}.desktop
	prepgamesdirs
}

pkg_preinst() {
	gnome2_icon_savelist
	games_pkg_preinst
}

pkg_postinst() {
	gnome2_icon_cache_update
	games_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
}
