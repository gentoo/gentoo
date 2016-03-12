# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FORTRAN_NEEDED="fortran"
FORTRAN_STANDARD="90 2003"

inherit cmake-utils fortran-2

DESCRIPTION="CFD General Notation System standard library"
HOMEPAGE="http://www.cgns.org/"
SRC_URI="https://github.com/CGNS/CGNS/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples fortran hdf5 legacy mpi static-libs szip test tools"

RDEPEND="hdf5? ( sci-libs/hdf5:=[mpi=,szip=] )
	tools? (
		dev-lang/tcl:=
		dev-lang/tk:=
		x11-libs/libXmu:=
		virtual/glu
		virtual/opengl
	)"
DEPEND="${RDEPEND}"

S="${WORKDIR}/CGNS-${PV}"

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	# gentoo libdir
	sed -e '/DESTINATION/s|lib)|lib${LIB_SUFFIX})|g' \
		-e 's|lib LIBDIR|lib${LIB_SUFFIX} LIBDIR|' \
		-e 's|/lib"|/lib${LIB_SUFFIX}"|'\
		-i CMakeLists.txt src/CMakeLists.txt || die
	# dont hard code link
	sed -e '/link_directories/d' \
		-i src/tools/CMakeLists.txt src/cgnstools/*/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCGNS_BUILD_SHARED=ON
		-DCGNS_USED_SHARED=ON
		-DCGNS_BUILD_CGNSTOOLS="$(usex tools)"
		-DCGNS_ENABLE_FORTRAN="$(usex fortran)"
		-DCGNS_ENABLE_HDF5="$(usex hdf5)"
		-DCGNS_ENABLE_LEGACY="$(usex legacy)"
		-DCGNS_ENABLE_TESTS="$(usex test)"
		-DHDF5_NEED_MPI="$(usex mpi)"
		-DHDF5_NEED_SZIP="$(usex szip)"
		-DHDF5_NEED_ZLIB="$(usex szip)"
	)
	cmake-utils_src_configure
}

src_compile() {
	# hack to allow parallel building by first producing fortran module
	use fortran && cd "${BUILD_DIR}"/src && emake cgns_f.o
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc README.md changelog release_docs/Release.txt
	use static-libs || rm "${ED}"/usr/$(get_libdir)/libcgns.a
	use doc && dodoc *pdf release_docs/*.pdf
	insinto /usr/share/doc/${PF}
	use examples && doins -r src/examples
}
