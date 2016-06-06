# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CMAKE_IN_SOURCE_BUILD=1
inherit cmake-utils eutils games

MY_P=CGenius-${PV}-Release-Source
DESCRIPTION="Open Source Commander Keen clone (needs original game files)"
HOMEPAGE="http://clonekeenplus.sourceforge.net"
SRC_URI="https://github.com/gerstrong/Commander-Genius/archive/v${PV//./}release.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="opengl tremor"
RESTRICT="mirror" # contains keen files, but we do not install them

RDEPEND="media-libs/libsdl2[X,opengl?,sound,video]
	media-libs/sdl2-image
	opengl? ( virtual/opengl )
	tremor? ( media-libs/tremor )
	!tremor? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}
	dev-libs/boost
	virtual/pkgconfig"

S=${WORKDIR}/Commander-Genius-${PV//./}release

src_prepare() {
	rm -rf vfsroot || die
	sed -i -e '/INCLUDE(package.cmake)/d' CMakeLists.txt || die
	cp version.h src/ || die # Workaround buggy neard package - bug #558160
}

src_configure() {
	local mycmakeargs=(
		-DAPPDIR="${GAMES_BINDIR}"
		-DSHAREDIR="/usr/share"
		-DGAMES_SHAREDIR="${GAMES_DATADIR}"
		-DDOCDIR="/usr/share/doc/${PF}"
		-DBUILD_TARGET="LINUX"
		$(cmake-utils_use opengl OPENGL)
		$(cmake-utils_use tremor TREMOR)
		$(cmake-utils_use !tremor OGG)
		-DUSE_SDL2=1
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	newicon src/CGLogo.png ${PN}.png
	newgamesbin "${FILESDIR}"/commandergenius-wrapper commandergenius
	if [[ -e "${ED}${GAMES_BINDIR}"/CGeniusExe ]] ; then
		mv "${ED}${GAMES_BINDIR}"/CGeniusExe \
			"${ED}${GAMES_BINDIR}"/CommanderGenius || die
	fi

	make_desktop_entry commandergenius
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "Check your settings in ~/.CommanderGenius/cgenius.cfg"
	elog "after you have started the game for the first time."
	use opengl && elog "You may also want to set \"OpenGL = true\""
	elog
	elog "Run the game via:"
	elog "    'commandergenius [path-to-keen-data]'"
	elog "or add your keen data dir to the search paths in cgenius.cfg"
}
