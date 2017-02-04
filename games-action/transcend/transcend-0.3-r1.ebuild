# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="Retro-style, abstract, 2D shooter"
HOMEPAGE="http://transcend.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/Transcend_${PV}_UnixSource.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	media-libs/freeglut
	media-libs/portaudio
	x11-libs/libXi
	x11-libs/libXmu
	virtual/glu
	virtual/opengl"
RDEPEND=${DEPEND}

S=${WORKDIR}/Transcend_${PV}_UnixSource/Transcend

# Apply patch from Debian in order to get sound working. bug #372413
PATCHES=(
	"${FILESDIR}"/${P}-sound.patch
)

src_prepare() {
	default

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
		-e "s:\"levels\":\"/usr/share/${PN}/levels\":" \
		game/LevelDirectoryManager.cpp \
		game/game.cpp || die
}

src_configure() { :; }

src_compile() {
	emake -C game
}

src_install() {
	newbin game/Transcend ${PN}
	insinto /usr/share/${PN}
	doins -r levels/
	dodoc doc/{how_to_play.txt,changeLog.txt}
	make_desktop_entry ${PN} "Transcend"
}
