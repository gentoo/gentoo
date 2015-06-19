# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/world-of-goo-demo/world-of-goo-demo-1.41-r1.ebuild,v 1.5 2015/01/09 16:11:18 mr_bones_ Exp $

EAPI=5
inherit eutils games

DESCRIPTION="A puzzle game with a strong emphasis on physics"
HOMEPAGE="http://2dboy.com/"

if [[ ${PN} == *-demo ]] ; then
	MY_PN="WorldOfGooDemo"
	SRC_URI="${MY_PN}.${PV}.tar.gz"
else
	MY_PN="WorldOfGoo"
	SRC_URI="${MY_PN}Setup.${PV}.tar.gz"
fi

LICENSE="2dboy-EULA"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="fetch strip"

RDEPEND="media-libs/libsdl[sound,opengl,video]
	media-libs/sdl-mixer[vorbis]
	sys-libs/glibc
	virtual/opengl
	virtual/glu
	>=sys-devel/gcc-3.4"
DEPEND=""

S=${WORKDIR}/${MY_PN}
dir=${GAMES_PREFIX_OPT}/${PN}

QA_PREBUILT="${dir:1}/${MY_PN%Demo}.bin32
	${dir:1}/${MY_PN%Demo}.bin64"

pkg_nofetch() {
	if [[ ${PN} == *-demo ]] ; then
		elog "To download the demo, visit http://worldofgoo.com/dl2.php?lk=demo"
		elog "and download ${A} and place it in ${DISTDIR}"
	else
		elog "Download ${A} from ${HOMEPAGE} and place it in ${DISTDIR}"
	fi
}

src_install() {
	exeinto "${dir}"
	doexe ${MY_PN%Demo}*

	games_make_wrapper ${PN} "${dir}"/${MY_PN%Demo}

	insinto "${dir}"
	doins -r icons properties res
	newicon icons/scalable.svg ${PN}.svg

	if [[ ${PN} == *-demo ]] ; then
		make_desktop_entry ${PN} "World of Goo (Demo)"
	else
		make_desktop_entry ${PN} "World of Goo"
	fi

	dodoc linux-issues.txt
	dohtml readme.html

	prepgamesdirs
}
