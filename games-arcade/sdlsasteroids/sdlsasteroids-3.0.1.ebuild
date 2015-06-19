# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/sdlsasteroids/sdlsasteroids-3.0.1.ebuild,v 1.8 2015/01/05 17:38:22 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Rework of Sasteroids using SDL"
HOMEPAGE="http://sdlsas.sourceforge.net/"
SRC_URI="mirror://sourceforge/sdlsas/SDLSasteroids-${PV}.tar.gz"

LICENSE="GPL-2 freedist"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/opengl
	media-libs/sdl-mixer
	media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}"
S=${WORKDIR}/SDLSasteroids-${PV}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-ldflags.patch
	sed -i \
		-e 's/make /$(MAKE) /' \
		-e 's/--strip//' \
		Makefile || die
	sed -i \
		-e '/^CC/d' \
		-e 's/g++/$(CXX)/' \
		-e 's/CC/CXX/' \
		-e 's/CFLAGS/CXXFLAGS/' \
		src/Makefile || die
}

src_compile() {
	emake \
		GAMEDIR="${GAMES_DATADIR}/${PN}" \
		OPTS="${CXXFLAGS}"
}

src_install() {
	dodir /usr/share/man/man6/
	emake \
		GAMEDIR="${D}/${GAMES_DATADIR}/${PN}" \
		BINDIR="${D}/${GAMES_BINDIR}" \
		MANDIR="${D}/usr/share/man/" \
		install
	dodoc ChangeLog README README.xast TODO description
	prepgamesdirs
}
