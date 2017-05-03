# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils versionator cmake-utils

MY_PV=build$(get_version_component_range 2)
MY_P=${PN}-${MY_PV}-src

DESCRIPTION="A game similar to Settlers 2"
HOMEPAGE="http://www.widelands.org/"
SRC_URI="https://launchpad.net/widelands/${MY_PV}/build-$(get_version_component_range 2)/+download/${MY_P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	dev-lang/lua:0
	>=dev-libs/boost-1.48:=
	media-libs/glew:0=
	media-libs/libpng:0=
	media-libs/libsdl[video]
	media-libs/sdl-gfx
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-net
	media-libs/sdl-ttf
	sys-libs/zlib[minizip]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

CMAKE_BUILD_TYPE=Release

PATCHES=(
	"${FILESDIR}"/${P}-cxxflags.patch
)

src_prepare() {
	cmake-utils_src_prepare

	sed -i -e 's:__ppc__:__PPC__:' src/s2map.cc || die
	sed -i -e '/WL_VERSION_MINOR/s/17/18/' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DWL_VERSION_STANDARD=true

		# Game is NOT happy being moved from /usr/share/games
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr/share/games/${PN}

		-DWL_INSTALL_PREFIX="${EPREFIX}"/usr/games
		-DWL_INSTALL_DATADIR="${EPREFIX}"/usr/share/games/${PN}
		-DWL_INSTALL_LOCALEDIR="${EPREFIX}"/usr/share/games/${PN}/locale
		-DWL_INSTALL_BINDIR="${EPREFIX}"/usr/bin
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newicon pics/wl-ico-128.png ${PN}.png
	make_desktop_entry ${PN} ${PN^}
}
