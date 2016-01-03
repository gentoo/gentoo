# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cmake-utils games

DESCRIPTION="3D arcade with unique fighting system and anthropomorphic characters"
HOMEPAGE="https://bitbucket.org/osslugaru/lugaru/wiki/Home"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+ free-noncomm CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/glu
	virtual/opengl
	media-libs/libsdl[opengl,video]
	media-libs/openal
	media-libs/libvorbis
	virtual/jpeg:0
	media-libs/libpng:0
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-dir.patch"
	sed -i \
		-e "s:@GENTOO_DIR@:${GAMES_DATADIR}/${PN}:" \
		Source/OpenGL_Windows.cpp || die
}

src_configure() {
	mycmakeargs=(
		"-DCMAKE_VERBOSE_MAKEFILE=TRUE"
		"-DLUGARU_FORCE_INTERNAL_OPENGL=False"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	dogamesbin "${WORKDIR}/${P}_build/lugaru"
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r Data/
	newicon Source/win-res/Lugaru.png ${PN}.png
	make_desktop_entry ${PN} Lugaru ${PN}
	prepgamesdirs
}
