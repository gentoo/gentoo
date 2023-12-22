# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A simple C++ geometry processing library"
HOMEPAGE="https://libigl.github.io/"
SRC_URI="https://github.com/libigl/libigl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="static-libs"

DEPEND="dev-cpp/eigen:3"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DLIBIGL_BUILD_TESTS=OFF
		-DLIBIGL_BUILD_TUTORIALS=OFF
		-DLIBIGL_USE_STATIC_LIBRARY=$(usex static-libs)
		-DLIBIGL_COPYLEFT_CGAL=OFF
		-DLIBIGL_COPYLEFT_COMISO=OFF
		-DLIBIGL_EMBREE=OFF
		-DLIBIGL_DEFAULT_MATLAB=OFF
		-DLIBIGL_DEFAULT_MOSEK=OFF
		-DLIBIGL_OPENGL=OFF
		-DLIBIGL_GLFW=OFF
		-DLIBIGL_IMGUI=OFF
		-DLIBIGL_STB=OFF
		-DLIBIGL_PREDICATES=OFF
		-DLIBIGL_SPECTRA=OFF
		-DLIBIGL_COPYLEFT_TETGEN=OFF
		-DLIBIGL_RESTRICTED_TRIANGLE=OFF
		-DLIBIGL_XML=OFF
	)
	cmake_src_configure
}

src_prepare() {
	cmake_src_prepare

	# Tries to copy eigen headers into /usr/include
	sed -e '/install(DIRECTORY/d' -i cmake/recipes/external/eigen.cmake || die
}

src_install() {
	cmake_src_install

	# Install won't install all headers
	insinto /usr/include/
	doins -r include/igl
}
