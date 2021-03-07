# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Program for reducing Feynman integrals"
HOMEPAGE="https://reduze.hepforge.org/"
SRC_URI="https://reduze.hepforge.org/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="berkdb doc examples mpi"

RDEPEND="
	>=sci-mathematics/ginac-1.4.1
	berkdb? ( sys-libs/db:6.0[cxx] )
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${PN}-2.2-db.patch
)

# remove bundled yaml-cpp
# no: it does not build. is it patched?
# sed -i -e '/add_subdirectory ("yaml")/d' CMakeLists.txt || die

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=ON # no thanks
		-DUSE_HASH_TABLE=ON
		-DUSE_DATABASE=$(usex berkdb)
		-DENABLE_EXAMPLES=$(usex examples)
		-DUSE_MPI=$(usex mpi)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile all $(usev doc)
}

src_test() {
	cmake_build check
	use mpi && cmake_build check_mpi
}

src_install() {
	use doc && local HTML_DOCS+=( "${BUILD_DIR}"/doc/code/html/. )
	cmake_src_install
}
