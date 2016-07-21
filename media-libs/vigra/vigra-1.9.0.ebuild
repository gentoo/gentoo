# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads,xml"

# This ebuild could use python-r1 in the future when upstream gets Python 3.x
# support working
inherit cmake-utils eutils multilib python-single-r1

MY_P=${P}-src

DESCRIPTION="a C++ computer vision library with emphasis on customizability of algorithms and data structures"
HOMEPAGE="http://hci.iwr.uni-heidelberg.de/vigra/"
SRC_URI="http://hci.iwr.uni-heidelberg.de/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc +fftw +hdf5 +jpeg openexr +png +python test +tiff"

# Pull in dev-lang/python:2.7 for vigra-config which is always installed
RDEPEND="dev-lang/python:2.7
	>=dev-libs/boost-1.52.0-r6:=[python?,${PYTHON_USEDEP}]
	fftw? ( sci-libs/fftw:3.0 )
	hdf5? ( sci-libs/hdf5:= )
	jpeg? ( virtual/jpeg )
	openexr? ( media-libs/openexr:= )
	png? ( media-libs/libpng:0= )
	python? ( ${PYTHON_DEPS} )
	tiff? ( media-libs/tiff:0= )"
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		python? ( >=dev-python/sphinx-1.1.3-r5[${PYTHON_USEDEP}] )
	)
	test? (
		python? ( >=dev-python/nose-1.1.2-r1[${PYTHON_USEDEP}] )
	)"
REQUIRED_USE="doc? ( hdf5 fftw )
	python? ( hdf5 ${PYTHON_REQUIRED_USE} )
	test? ( hdf5 python fftw )"

DOCS=( README.txt )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-automagicness.patch

	# Don't build nor install API docs when not requested
	use doc || { sed -i -e '/ADD_SUBDIRECTORY(docsrc)/d' CMakeLists.txt || die; }

	# Don't use python_fix_shebang because we can't put this behind USE="python"
	sed -i -e '/env/s:python:python2:' config/vigra-config.in || die
}

src_configure() {
	local libdir=$(get_libdir)

	# required for ddocdir
	_cmake_check_build_dir init
	local mycmakeargs=(
		-DDOCDIR="${CMAKE_BUILD_DIR}"/doc
		-DLIBDIR_SUFFIX=${libdir/lib}
		-DDOCINSTALL=share/doc/${PF}
		-DWITH_VALGRIND=OFF
		$(cmake-utils_use_with python VIGRANUMPY)
		$(cmake-utils_use_with png)
		$(cmake-utils_use_with jpeg)
		$(cmake-utils_use_with openexr)
		$(cmake-utils_use_with tiff)
		$(cmake-utils_use_with fftw FFTW3)
		$(cmake-utils_use_with hdf5)
		$(cmake-utils_use_build test TESTING)
		$(cmake-utils_use test CREATE_CTEST_TARGETS)
		$(cmake-utils_use test AUTOBUILD_TESTS)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_make doc
}

src_test() { :; } #390447

src_install() {
	cmake-utils_src_install

	use python && python_optimize
}
