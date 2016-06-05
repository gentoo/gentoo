# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit cmake-utils flag-o-matic python-single-r1 toolchain-funcs versionator

MYPV=$(get_version_component_range 1-2)
MYPD=${PN}-data-0.9

DESCRIPTION="Large Scale Machine Learning Toolbox"
HOMEPAGE="http://shogun-toolbox.org/"
SRC_URI="
	ftp://shogun-toolbox.org/shogun/releases/${MYPV}/sources/${P}.tar.bz2
	test? ( ftp://shogun-toolbox.org/shogun/data/${MYPD}.tar.bz2 )
	examples? ( ftp://shogun-toolbox.org/shogun/data/${MYPD}.tar.bz2 )"

LICENSE="GPL-3 free-noncomm"
SLOT="0/16"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples lua mono octave python R ruby static-libs test"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( python )"

RDEPEND="
	app-arch/bzip2:=
	app-arch/gzip:=
	app-arch/lzma:=
	app-arch/snappy:=
	dev-libs/lzo:=
	>=dev-cpp/eigen-3.1
	dev-libs/json-c:=
	dev-libs/libxml2:=
	dev-libs/protobuf:=
	net-misc/curl:=
	sci-libs/arpack:=
	sci-libs/arprec:=
	sci-libs/colpack:=
	sci-libs/hdf5:=
	sci-libs/nlopt:=
	sci-mathematics/glpk:=
	sci-mathematics/lpsolve:=
	sys-libs/readline:0
	sys-libs/zlib:=
	virtual/blas
	virtual/cblas
	virtual/lapack
	lua? ( dev-lang/lua:0 )
	mono? ( dev-lang/mono )
	octave? ( <sci-mathematics/octave-3.8.0[hdf5] )
	python? ( dev-python/numpy[${PYTHON_USEDEP}] )
	R? ( dev-lang/R )
	ruby? ( dev-ruby/narray )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	lua? ( >=dev-lang/swig-2.0.4 )
	mono? ( >=dev-lang/swig-2.0.4 )
	octave? ( >=dev-lang/swig-2.0.4 )
	python? ( >=dev-lang/swig-2.0.4 test? ( sci-libs/scipy ) )
	R? ( >=dev-lang/swig-2.0.4 )
	ruby? ( >=dev-lang/swig-2.0.4 )
	test? (
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-cpp/gmock
		)"

# javamodular needs jblas (painful to package properly)
# permodular work in progress (as 3.2.0)
# could actually support multiple pythons, multiple rubys
# feel free to do work for it

PATCHES=(
	"${FILESDIR}"/${P}-fix-buildsystem.patch
	"${FILESDIR}"/${P}-remove-C-linkage.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	export ATLAS_LIBRARY="$($(tc-getPKG_CONFIG) --libs cblas lapack)"
	export CBLAS_LIBRARY="$($(tc-getPKG_CONFIG) --libs cblas)"
	export ATLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs blas cblas lapack)"
	export LAPACK_LIBRARIES="$($(tc-getPKG_CONFIG) --libs lapack)"

	append-cppflags "$($(tc-getPKG_CONFIG) --cflags cblas)"

	local mycmakeargs=(
		-DCMAKE_SKIP_INSTALL_RPATH=ON
		-DCMAKE_SKIP_RPATH=ON
		-DBUNDLE_ARPREC=OFF
		-DBUNDLE_COLPACK=OFF
		-DBUNDLE_EIGEN=OFF
		-DBUNDLE_JSON=OFF
		-DBUNDLE_NLOPT=OFF
		-DENABLE_COVERAGE=OFF
		-DJavaModular=OFF
		-DPerlModular=OFF
		-DLIB_INSTALL_DIR=$(get_libdir)
		-DLuaModular="$(usex lua)"
		-DCSharpModular="$(usex mono)"
		-DOctaveModular="$(usex octave)"
		-DOctaveStatic="$(usex octave)"
		-DPythonModular="$(usex python)"
		-DPythonStatic="$(usex python)"
		-DRModular="$(usex R)"
		-DRStatic="$(usex R)"
		-DRubyModular="$(usex ruby)"
		-DENABLE_TESTING="$(usex test)"
		-DBUILD_EXAMPLES="$(usex examples)"
	)
	cmake-utils_src_configure
	# gentoo bug #302621
	has_version sci-libs/hdf5[mpi] && export CXX=mpicxx CC=mpicc
}

src_compile() {
	cmake-utils_src_compile
	use doc && emake -C "${BUILD_DIR}"/doc
}
