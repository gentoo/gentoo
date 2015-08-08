# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

DESCRIPTION="retro-style, abstract, 2D shooter"
HOMEPAGE="http://transcend.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/Transcend_${PV}_UnixSource.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="x11-libs/libXmu
	x11-libs/libXi
	virtual/opengl
	virtual/glu
	media-libs/freeglut"
RDEPEND=${DEPEND}

S=${WORKDIR}/Transcend_${PV}_UnixSource/Transcend

src_prepare() {
	chmod a+x portaudio/configure
	mkdir portaudio/{lib,bin}
	rm -f game/Makefile
	sed \
		-e '/^GXX=/d' \
		-e 's/GXX/CXX/' \
		-e '/^COMPILE_FLAGS =/ s/OPTIMIZE_FLAG/CXXFLAGS/' \
		-e '/^EXE_LINK =/ s/LINK_FLAGS/LDFLAGS/' \
		Makefile.GnuLinuxX86 \
		Makefile.common \
		Makefile.minorGems \
		game/Makefile.all \
		Makefile.minorGems_targets \
		> game/Makefile || die
	sed -i \
		-e "s:\"levels\":\"${GAMES_DATADIR}/${PN}/levels\":" \
		game/LevelDirectoryManager.cpp \
		game/game.cpp || die
}

src_configure() {
	cd portaudio
	egamesconf
}

src_compile() {
	emake -C portaudio lib/libportaudio.a
	emake -C game
	cp game/Transcend ${PN} || die
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r levels/
	dodoc doc/{how_to_play.txt,changeLog.txt}
	prepgamesdirs
}
