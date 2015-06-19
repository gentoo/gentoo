# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/dont-starve/dont-starve-2.ebuild,v 1.3 2015/02/10 10:13:48 ago Exp $

EAPI=5

inherit eutils games

DESCRIPTION="Wilderness survival game full of science and magic"
HOMEPAGE="http://www.dontstarvegame.com/"
SRC_URI="amd64? ( dontstarve_x64_july21.tar.gz )
	x86? ( dontstarve_x32_july21.tar.gz )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="fetch bindist splitdebug"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/bin/dontstarve"
if [[ $ARCH == amd64 ]] ; then
	QA_PREBUILT="${QA_PREBUILT}
		${MYGAMEDIR#/}/bin/lib64/*"
elif [[ ${ARCH} == x86 ]] ; then
	QA_PREBUILT="${QA_PREBUILT}
		${MYGAMEDIR#/}/bin/lib32/*"
fi

RDEPEND="net-misc/curl
	virtual/opengl"

S=${WORKDIR}/dontstarve

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_install() {
	local libdir=lib$(usex amd64 "64" "32")

	insinto "${MYGAMEDIR}"
	doins -r data mods

	exeinto "${MYGAMEDIR}"/bin
	doexe bin/dontstarve
	exeinto "${MYGAMEDIR}"/bin/${libdir}
	doexe bin/${libdir}/libfmod*
	# unbundling libsdl2 breaks the menu, so you cannot start the game
	doexe bin/${libdir}/libSDL2*

	games_make_wrapper ${PN} "./dontstarve" "${MYGAMEDIR}/bin" "${MYGAMEDIR}/bin/${libdir}"
	make_desktop_entry ${PN}

	doicon dontstarve.xpm

	prepgamesdirs
}
