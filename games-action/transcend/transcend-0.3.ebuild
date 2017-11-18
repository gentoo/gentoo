# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils games

DESCRIPTION="retro-style, abstract, 2D shooter"
HOMEPAGE="http://transcend.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/Transcend_${PV}_UnixSource.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libXmu
	x11-libs/libXi
	virtual/opengl
	virtual/glu
	media-libs/portaudio
	media-libs/freeglut"
RDEPEND=${DEPEND}

S=${WORKDIR}/Transcend_${PV}_UnixSource/Transcend

src_prepare() {
	# apply patch from debian in order to get sound working. bug #372413
	epatch "${FILESDIR}"/${P}-sound.patch
	rm -rf game/Makefile portaudio/ || die
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

src_configure() { :; }

src_compile() {
	emake -C game
}

src_install() {
	newgamesbin game/Transcend ${PN}
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r levels/
	dodoc doc/{how_to_play.txt,changeLog.txt}
	make_desktop_entry ${PN} "Transcend"
	prepgamesdirs
}
