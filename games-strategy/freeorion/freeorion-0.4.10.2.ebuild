# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_8,3_9} )
inherit cmake python-single-r1 xdg

DESCRIPTION="A free turn-based space empire and galactic conquest game"
HOMEPAGE="https://www.freeorion.org"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/freeorion/freeorion.git"
else
	KEYWORDS="~amd64"
	if [[ ${PV} = *_p* ]]; then
		COMMIT=""
		SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${PN}-${COMMIT}"
	else
		SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${PN}-${PV/_/-}"
	fi
fi

LICENSE="GPL-2 LGPL-2.1 CC-BY-SA-3.0"
SLOT="0"
IUSE="dedicated"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-libs/boost-1.58:=[nls,python,threads(+),${PYTHON_USEDEP}]
	')
	!dedicated? (
		media-libs/freealut
		>=media-libs/freetype-2.5.5
		media-libs/glew:=
		>=media-libs/libogg-1.1.3
		media-libs/libpng:0=
		media-libs/libsdl2[X,opengl,video]
		>=media-libs/libvorbis-1.1.2
		media-libs/openal
		sci-physics/bullet:=
		virtual/opengl
	)
	sys-libs/zlib
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e "s/-O3//" -i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_HEADLESS="$(usex dedicated)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newenvd "${FILESDIR}/${PN}.envd" 99${PN}
}
