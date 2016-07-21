# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils scons-utils games

MY_PN=${PN/c/C}
DESCRIPTION="3D and open source chess game"
HOMEPAGE="http://pouetchess.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_src_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug"

DEPEND="media-libs/libsdl:0[opengl,video]
	media-libs/sdl-image[jpeg,png]
	virtual/glu
	virtual/opengl"
RDEPEND=${DEPEND}

S=${WORKDIR}/${PN}_src_${PV}

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-sconstruct-sandbox.patch" \
		"${FILESDIR}/${P}-nvidia_glext.patch" \
		"${FILESDIR}/${P}-segfaults.patch" \
		"${FILESDIR}/${P}-gcc43.patch"
	# Fix for LibSDL >= 1.2.10 detection
	sed -i \
		-e "s:sdlver.split('.') >= \['1','2','8'\]:sdlver.split('.') >= [1,2,8]:" \
		pouetChess.py || die
}

src_configure() {
	# turn off the hackish optimization setting code (bug #230127)
	scons configure \
		strip=false \
		optimize=false \
		prefix="${GAMES_PREFIX}" \
		datadir="${GAMES_DATADIR}"/${PN} \
		$(use debug && echo debug=1) || die
}

src_compile() {
	escons
}

src_install() {
	dogamesbin bin/${MY_PN}

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/*

	dodoc ChangeLog README

	doicon data/icons/${MY_PN}.png
	make_desktop_entry ${MY_PN} ${MY_PN} ${MY_PN} "KDE;Qt;Game;BoardGame"

	prepgamesdirs
}
