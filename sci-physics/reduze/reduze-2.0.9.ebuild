# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Program for reducing Feynman integrals"
HOMEPAGE="http://reduze.hepforge.org/"
SRC_URI="http://reduze.hepforge.org/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="berkdb doc mpi"

RDEPEND=">=sci-mathematics/ginac-1.4.1
	berkdb? ( sys-libs/db[cxx] )
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=( ChangeLog README )

src_prepare() {
	# gentoo doc directory
	sed -i \
		-e "s:share/reduze:share/doc/${PF}:g" \
		CMakeLists.txt || die
	use doc || sed -i -e '/share/d' CMakeLists.txt
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
		$(cmake-utils_use berkdb USE_DATABASE)
		$(cmake-utils_use mpi USE_MPI)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile all $(use doc && echo doc)
}

src_test() {
	cd "${CMAKE_BUILD_DIR}"
	emake check
	use mpi && emake check_mpi
}

src_install() {
	cmake-utils_src_install
	use doc && dohtml -r "${CMAKE_BUILD_DIR}"/doc/code/html/*
}
