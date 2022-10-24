# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit cmake python-any-r1 xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/widelands/widelands.git"
else
	SRC_URI="https://github.com/widelands/widelands/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

DESCRIPTION="Game similar to Settlers 2"
HOMEPAGE="https://www.widelands.org/"

LICENSE="GPL-2+ || ( Apache-2.0 GPL-3 ) BitstreamVera CC-BY-SA-3.0 MIT OFL-1.1"
SLOT="0"
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
	sys-libs/zlib:=[minizip]
	virtual/libintl"
DEPEND="
	${RDEPEND}
	dev-cpp/asio"
BDEPEND="
	${PYTHON_DEPS}
	sys-devel/gettext"

src_configure() {
	CMAKE_BUILD_TYPE=Release # disables -Werror

	local mycmakeargs=(
		-DWL_INSTALL_BASEDIR="${EPREFIX}"/usr/share/doc/${PF}
		-DWL_INSTALL_BINDIR="${EPREFIX}"/usr/bin
		-DWL_INSTALL_DATADIR="${EPREFIX}"/usr/share/${PN}
		-DGTK_UPDATE_ICON_CACHE=OFF
		-DOPTION_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
