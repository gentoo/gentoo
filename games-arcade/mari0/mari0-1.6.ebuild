# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils gnome2-utils games

MY_P=${P/-/_}

DESCRIPTION="A mix from Nintendo's Super Mario Bros and Valve's Portal"
HOMEPAGE="http://stabyourself.net/mari0/"
SRC_URI="${P}.zip
	mirror://gentoo/mari0.svg.gz"

LICENSE="CC-BY-NC-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""
RESTRICT="fetch" # unsure about legality of graphics

RDEPEND=">=games-engines/love-0.8.0
	 media-libs/devil[gif,png]"
DEPEND="app-arch/unzip"

S=${WORKDIR}

pkg_nofetch() {
	einfo "Please download ${PN}-source.zip from:"
	einfo "http://stabyourself.net/${PN}/#download"
	einfo "Move it to ${DISTDIR} and rename it to ${P}.zip"
	echo
}

src_install() {
	local dir=${GAMES_DATADIR}/love/${PN}

	exeinto "${dir}"
	doexe ${MY_P}.love

	doicon -s scalable ${PN}.svg
	games_make_wrapper ${PN} "love ${MY_P}.love" "${dir}"
	make_desktop_entry ${PN}

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	elog "${PN} savegames and configurations are stored in:"
	elog "~/.local/share/love/${PN}/"

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
