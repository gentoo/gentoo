# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Simulated obstacle course for automobiles"
HOMEPAGE="http://www.stolk.org/stormbaancoureur/"
SRC_URI="http://www.stolk.org/stormbaancoureur/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/glu
	media-libs/freeglut
	>=dev-games/ode-0.8
	>=media-libs/plib-1.8.4
	media-libs/alsa-lib"
RDEPEND=${DEPEND}

S=${WORKDIR}/${P}/src-${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -ie "s:GENTOODIR:${GAMES_DATADIR}/${PN}:" main.cxx || die
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r images/ models/ sounds/ shaders/
	dodoc JOYSTICKS README TODO
	make_desktop_entry ${PN} "Stormbaan Coureur"
	prepgamesdirs
}
