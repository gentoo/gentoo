# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit xdg cmake python-any-r1

MY_PV="build$(ver_cut 2)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Game similar to Settlers 2"
HOMEPAGE="https://www.widelands.org/"
SRC_URI="https://launchpad.net/widelands/${MY_PV}/${MY_PV}/+download/${MY_P}-source.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="|| ( Apache-2.0 GPL-3 ) BitstreamVera CC-BY-SA-3.0 GPL-2 GPL-2+ MIT OFL-1.1 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/icu:=
	media-libs/glew:0=
	media-libs/libglvnd
	media-libs/libpng:=
	media-libs/libsdl2[opengl,sound,video]
	media-libs/sdl2-image[jpeg,png]
	media-libs/sdl2-mixer[vorbis]
	media-libs/sdl2-ttf
	sys-libs/zlib:=
	virtual/libintl"
DEPEND="
	${RDEPEND}
	dev-libs/boost"
BDEPEND="
	${PYTHON_DEPS}
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${PN}-0.20_rc1-cxxflags.patch
)

src_configure() {
	CMAKE_BUILD_TYPE="Release"

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr/bin
		-DWL_INSTALL_BASEDIR="${EPREFIX}"/usr/share/doc/${PF}
		-DWL_INSTALL_DATADIR="${EPREFIX}"/usr/share/${PN}
		-DGTK_UPDATE_ICON_CACHE=OFF
		-DOPTION_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
