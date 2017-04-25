# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit cmake-utils python-any-r1 gnome2-utils

DESCRIPTION="A free turn-based space empire and galactic conquest game"
HOMEPAGE="http://www.freeorion.org"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/freeorion/freeorion.git"
else
	RELDATE=2016-09-16
	SHA=49f9123
	SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/FreeOrion_v${PV}_${RELDATE}.${SHA}_Source.tar.gz -> ${P}.tar.gz"
	# Issue with version.cpp, TODO fix
	#SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"

	S="${WORKDIR}/src-tarball"
fi

LICENSE="GPL-2 LGPL-2.1 CC-BY-SA-3.0"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-libs/boost-1.56[python,threads]
	media-libs/freealut
	media-libs/freetype
	media-libs/glew:*
	media-libs/libsdl2
	>=media-libs/libogg-1.1.3
	media-libs/libpng:0
	media-libs/libsdl2[X,opengl,video]
	>=media-libs/libvorbis-1.1.2
	media-libs/openal
	sci-physics/bullet
	sys-libs/zlib
	virtual/opengl
	!dev-games/gigi"
	# Use bundled gigi as of freeorion-0.4.3

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

pkg_setup() {
	# build system is using FindPythonLibs.cmake which needs python:2
	python-any-r1_pkg_setup
}

src_prepare() {
	sed -e "s/-O3//" -i CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPEE=Release
		-DRELEASE_COMPILE_FLAGS=""
		-DCMAKE_SKIP_RPATH=ON
	)

	append-cppflags -DBOOST_OPTIONAL_CONFIG_USE_OLD_IMPLEMENTATION_OF_OPTIONAL

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc ChangeLog.md

	newenvd "${FILESDIR}/${PN}.envd" 99${PN}
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
