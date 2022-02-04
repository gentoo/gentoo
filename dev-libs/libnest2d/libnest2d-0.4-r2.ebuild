# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Library and framework for the 2D bin packaging problem"
HOMEPAGE="https://github.com/tamasmeszaros/libnest2d"
SRC_URI="https://github.com/tamasmeszaros/libnest2d/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/1"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE="examples static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/boost
	dev-libs/clipper
	sci-libs/nlopt
	"
DEPEND="${RDEPEND}
	test? ( >=dev-cpp/catch-2.9.1 )
	"

PATCHES=(
	"${FILESDIR}"/${P}-add-disallowed-areas.patch
	"${FILESDIR}"/${P}-add-soversion-to-shared-library.patch
	"${FILESDIR}"/${P}-fix-cpp-version.patch
	"${FILESDIR}"/${P}-gnu-install-dirs.patch
	)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DLIBNEST2D_BUILD_EXAMPLES=$(usex examples)
		-DLIBNEST2D_HEADER_ONLY=$(usex static-libs OFF ON)
		-DLIBNEST2D_BUILD_UNITTESTS=$(usex test)
		-DCMAKE_INSTALL_LIBDIR=$(get_libdir)
	)
	cmake_src_configure
}
