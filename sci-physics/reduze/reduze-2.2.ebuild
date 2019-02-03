# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Program for reducing Feynman integrals"
HOMEPAGE="http://reduze.hepforge.org/"
SRC_URI="http://reduze.hepforge.org/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="berkdb doc mpi"

RDEPEND=">=sci-mathematics/ginac-1.4.1
	berkdb? ( sys-libs/db:6.0[cxx] )
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

PATCHES=( "${FILESDIR}"/${P}-db.patch )

src_prepare() {
	cmake-utils_src_prepare
	# gentoo doc directory
	sed -i \
		-e "s:share/reduze:share/doc/${PF}:g" \
		CMakeLists.txt || die
	if ! use doc ; then
		sed -i -e '/share/d' CMakeLists.txt || die
	fi
	# prefix fix
	sed -i \
		-e "s:/usr:${EPREFIX}/usr:g" \
		reduze/CMakeLists.txt  || die

	# remove bundled yaml-cpp
	# no: it does not build. is it patched?
	# sed -i -e '/add_subdirectory ("yaml")/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_HASH_TABLE=ON
		-DUSE_DATABASE=$(usex berkdb)
		-DUSE_MPI=$(usex mpi)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile all $(usev doc)
}

src_test() {
	cmake-utils_src_compile check
	use mpi && cmake-utils_src_compile check_mpi
}

src_install() {
	use doc && HTML_DOCS+=( "${BUILD_DIR}"/doc/code/html/. )
	cmake-utils_src_install
}
