# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils versionator cmake-utils games

MY_PV=build$(get_version_component_range 2)
MY_P=${PN}-${MY_PV}-src
DESCRIPTION="A game similar to Settlers 2"
HOMEPAGE="http://www.widelands.org/"
SRC_URI="https://launchpad.net/widelands/${MY_PV}/build-$(get_version_component_range 2)/+download/${MY_P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-lang/lua:0
	media-libs/libsdl[video]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-gfx
	media-libs/sdl-net
	media-libs/libpng:0
	sys-libs/zlib[minizip]
	media-libs/glew
	media-libs/sdl-ttf
	>=dev-libs/boost-1.48"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

CMAKE_BUILD_TYPE=Release
PREFIX=${GAMES_DATADIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-cxxflags.patch
	sed -i -e 's:__ppc__:__PPC__:' src/s2map.cc || die
	sed -i -e '/WL_VERSION_MINOR/s/17/18/' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		'-DWL_VERSION_STANDARD=true'
		"-DWL_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-DWL_INSTALL_DATADIR=${GAMES_DATADIR}/${PN}"
		"-DWL_INSTALL_LOCALEDIR=${GAMES_DATADIR}/${PN}/locale"
		"-DWL_INSTALL_BINDIR=${GAMES_BINDIR}"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	newicon pics/wl-ico-128.png ${PN}.png
	make_desktop_entry ${PN} Widelands
	dodoc ChangeLog CREDITS
	prepgamesdirs
}
