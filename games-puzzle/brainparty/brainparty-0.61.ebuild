# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/brainparty/brainparty-0.61.ebuild,v 1.6 2015/01/23 21:44:21 mr_bones_ Exp $

EAPI=5
inherit eutils games

DESCRIPTION="A puzzle-solving, brain-stretching game for all ages"
HOMEPAGE="http://www.tuxradar.com/brainparty"
SRC_URI="http://launchpad.net/brainparty/trunk/${PV}/+download/${PN}${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,opengl,video]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	media-libs/sdl-image[png]
	media-libs/sdl-gfx"
RDEPEND=${DEPEND}

S=${WORKDIR}/${PN}

src_prepare() {
	sed -i \
		-e 's/$(LIBS) $(OSXCOMPAT) $(OBJFILES)/$(OSXCOMPAT) $(OBJFILES) $(LIBS)/' \
		-e 's/CXXFLAGS = .*/CXXFLAGS+=-c/' \
		-e '/^CXX =/d' \
		-e '/-o brainparty/s/INCLUDES) /&$(LDFLAGS) /' \
		Makefile || die
	sed -i \
		"/^int main(/ a\\\\tchdir(\"${GAMES_DATADIR}/${PN}\");\n" \
		main.cpp || die
	epatch \
		"${FILESDIR}"/${P}-savegame.patch \
		"${FILESDIR}"/${P}-gcc49.patch

}

src_install() {
	dogamesbin brainparty
	insinto "${GAMES_DATADIR}/${PN}/Content"
	doins Content/*
	newicon Content/icon.bmp ${PN}.bmp
	make_desktop_entry brainparty "Brain Party" /usr/share/pixmaps/${PN}.bmp
	prepgamesdirs
}
