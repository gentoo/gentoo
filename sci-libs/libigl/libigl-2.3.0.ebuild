# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A simple C++ geometry processing library"
HOMEPAGE="https://libigl.github.io/"
SRC_URI="https://github.com/libigl/libigl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="static-libs"

DEPEND="dev-cpp/eigen:3"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DLIBIGL_BUILD_TESTS=OFF
		-DLIBIGL_BUILD_TUTORIALS=OFF
		-DLIBIGL_SKIP_DOWNLOAD=ON
		-DLIBIGL_USE_STATIC_LIBRARY=$(usex static-libs)
		-DLIBIGL_WITH_CGAL=OFF
		-DLIBIGL_WITH_COMISO=OFF
		-DLIBIGL_WITH_EMBREE=OFF
		-DLIBIGL_WITH_MATLAB=OFF
		-DLIBIGL_WITH_MOSEK=OFF
		-DLIBIGL_WITH_OPENGL=OFF
		-DLIBIGL_WITH_OPENGL_GLFW=OFF
		-DLIBIGL_WITH_OPENGL_GLFW_IMGUI=OFF
		-DLIBIGL_WITH_PNG=OFF
		-DLIBIGL_WITH_PREDICATES=OFF
		-DLIBIGL_WITH_PYTHON=OFF
		-DLIBIGL_WITH_TETGEN=OFF
		-DLIBIGL_WITH_TRIANGLE=OFF
		-DLIBIGL_WITH_XML=OFF
	)
	cmake_src_configure
}

src_install() {
		cmake_src_install

		# Install won't install all headers
		insinto /usr/include/
		doins -r include/igl
}
