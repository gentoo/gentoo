# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

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
IUSE="cpu_flags_x86_sse doc examples lua octave opencl python R ruby static-libs test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( python )"

RDEPEND="
	app-arch/bzip2
	app-arch/gzip
	app-arch/lzma
	app-arch/snappy
	dev-libs/lzo
	dev-cpp/eigen:3
	dev-libs/json-c:=
	dev-libs/libxml2
	dev-libs/protobuf:=
	net-misc/curl
	sci-libs/arpack
	sci-libs/arprec
	sci-libs/colpack
	sci-libs/hdf5:=
	sci-libs/nlopt
	sci-mathematics/glpk:=
	sci-mathematics/lpsolve:=
	sys-libs/readline:0=
	sys-libs/zlib
	virtual/blas
	virtual/cblas
	virtual/lapack
	lua? ( dev-lang/lua:0 )
	octave? ( >=sci-mathematics/octave-4.2.0:=[hdf5] )
	opencl? ( virtual/opencl )
	python? (
		${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	R? ( dev-lang/R )
	ruby? ( dev-ruby/narray )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		>=app-doc/doxygen-1.8.13-r1[dot]
		dev-python/sphinx
	)
	lua? ( >=dev-lang/swig-3.0.12 )
	octave? ( >=dev-lang/swig-3.0.12 )
	python? (
		>=dev-lang/swig-3.0.12
		test? (
			sci-libs/scipy
		)
	)
	R? ( >=dev-lang/swig-3.0.12 )
	ruby? ( >=dev-lang/swig-3.0.12 )
	test? (
		dev-python/jinja[${PYTHON_USEDEP}]
		>=dev-cpp/gtest-1.8.0
	)"

# javamodular needs jblas (painful to package properly)
# permodular work in progress (as 3.2.0)
# could actually support multiple pythons, multiple rubys
# feel free to do work for it

PATCHES=(
	"${FILESDIR}"/${PN}-5.0.0-fix-buildsystem.patch
	"${FILESDIR}"/${PN}-4.1.0-remove-C-linkage.patch
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
		-DCMAKE_SKIP_RPATH=ON
		-DCMAKE_SKIP_INSTALL_RPATH=ON
		-DLIB_INSTALL_DIR=$(get_libdir)
		-DENABLE_TESTING=$(usex test)
		-DBUILD_EXAMPLES=$(usex examples)
		-DDISABLE_SSE=$(usex !cpu_flags_x86_sse)
		-DCMAKE_DISABLE_FIND_PACKAGE_Pandoc=ON
		$(cmake-utils_use_find_package doc Sphinx)
		$(cmake-utils_use_find_package doc Doxygen)

		# Features:
		-DENABLE_COVERAGE=OFF
		-DENABLE_COLPACK=ON
		-DENABLE_PROTOBUF=ON
		-DENABLE_PYTHON_DEBUG=OFF
		-DENABLE_VIENNACL=$(usex opencl)
		-DUSE_ARPREC=ON
		-DUSE_HDF5=ON

		# Bindings:
		-DJavaModular=OFF
		-DPerlModular=OFF
		-DCSharpModular=OFF
		-DLuaModular=$(usex lua)
		-DOctaveModular=$(usex octave)
		-DPythonModular=$(usex python)
		-DRModular=$(usex R)
		-DRubyModular=$(usex ruby)

		# Disable bundled libs
		-DBUNDLE_COLPACK=OFF
		-DBUNDLE_JSON=OFF
		-DBUNDLE_NLOPT=OFF
	)
	cmake-utils_src_configure

	# gentoo bug #302621
	has_version 'sci-libs/hdf5[mpi]' && export CXX=mpicxx CC=mpicc
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_compile -C doc
}

src_install() {
	cmake-utils_src_install

	if use doc; then
		local i
		for i in lua octave python R ruby; do
			if use $i; then
				docinto html/${i,}_modular
				dodoc -r "${BUILD_DIR}"/src/interfaces/${i,}_modular/modshogun/doxygen_xml/.
			fi
		done
	fi
}
