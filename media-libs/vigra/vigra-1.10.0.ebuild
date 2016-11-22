# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MY_P=${P}-src-with-docu
MY_V=${PV//\./-}
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads,xml"
inherit cmake-utils python-r1

DESCRIPTION="C++ computer vision library with emphasize on customizable algorithms and data structures"
HOMEPAGE="https://ukoethe.github.io/vigra/"
SRC_URI="https://github.com/ukoethe/vigra/releases/download/Version-${MY_V}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc +fftw +hdf5 +jpeg mpi openexr +png +python test +tiff"

# runtime dependency on python:2.7 is required by the vigra-config script
RDEPEND="
	dev-lang/python:2.7
	>=dev-libs/boost-1.52.0-r6:=[python?,${PYTHON_USEDEP}]
	fftw? ( sci-libs/fftw:3.0 )
	hdf5? ( >=sci-libs/hdf5-1.8.0:=[mpi?] )
	jpeg? ( virtual/jpeg )
	openexr? ( media-libs/openexr:= )
	png? ( media-libs/libpng:0= )
	python? ( ${PYTHON_DEPS} dev-python/numpy[${PYTHON_USEDEP}] )
	tiff? ( media-libs/tiff:0= )"

DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		python? ( >=dev-python/sphinx-1.1.3-r5[${PYTHON_USEDEP}] )
	)
	test? ( >=dev-python/nose-1.1.2-r1[${PYTHON_USEDEP}] )"

REQUIRED_USE="
	doc? ( hdf5 fftw )
	python? ( hdf5 ${PYTHON_REQUIRED_USE} )
	test? ( hdf5 python fftw )"

PATCHES=(
	"${FILESDIR}/${P}-automagicness.patch"
	"${FILESDIR}/${P}-cmake-scripts.patch"
	"${FILESDIR}/${P}-mpi-fixes.patch"
)
DOCS=( README.md )

pkg_setup() {
	use python && python_setup
}

src_prepare() {
	einfo "Removing shipped doc, Win32 dependencies and VCS files"
	rm -rf doc
	rm vigra-dependencies-win32-vs8.zip
	rm .git* .hg* .travis.yml

	cmake-utils_src_prepare

	# Don't use python_fix_shebang because we can't put this behind USE="python"
	sed -i -e '/env/s:python:python2:' config/vigra-config.in || die
}

src_configure() {
	vigra_configure() {
		local libdir="$(get_libdir)"

		local mycmakeargs=(
			-DAUTOEXEC_TESTS=OFF
			-DDOCDIR="${BUILD_DIR}/doc"
			-DDOCINSTALL="share/doc/${P}"
			-DLIBDIR_SUFFIX="${libdir/lib}"
			-DWITH_VALGRIND=OFF
			$(cmake-utils_use_enable doc DOC)
			$(cmake-utils_use_with fftw FFTW3)
			$(cmake-utils_use_with hdf5 HDF5)
			$(cmake-utils_use_with jpeg JPEG)
			$(cmake-utils_use_with mpi MPI)
			$(cmake-utils_use_with png PNG)
			$(cmake-utils_use_with openexr OPENEXR)
			$(cmake-utils_use_with python VIGRANUMPY)
			$(cmake-utils_use_with tiff TIFF)
			$(cmake-utils_use_build test TESTING)
			$(cmake-utils_use test CREATE_CTEST_TARGETS)
			$(cmake-utils_use test AUTOBUILD_TESTS)
		)
		cmake-utils_src_configure
	}

	if use python; then
		python_foreach_impl vigra_configure
	else
		# required for docdir
		_cmake_check_build_dir init
		vigra_configure
	fi
}

src_compile() {
	local VIGRA_BUILD_DIR
	vigra_compile() {
		cmake-utils_src_compile
		VIGRA_BUILD_DIR="${BUILD_DIR}"
	}
	if use python; then
		python_foreach_impl vigra_compile
	else
		vigra_compile
	fi

	if use doc; then
		einfo "Generating Documentation"
		# use build dir from last compile command
		BUILD_DIR="${VIGRA_BUILD_DIR}" cmake-utils_src_make doc
	fi
}

src_install() {
	if use python; then
		python_foreach_impl cmake-utils_src_install
		python_optimize
	else
		cmake-utils_src_install
	fi
}

src_test() {
	# perhaps disable tests (see #390447)
	vigra_test() {
		PYTHONPATH="${BUILD_DIR}/vigranumpy/vigra" cmake-utils_src_test
	}
	if use python; then
		python_foreach_impl vigra_test
	else
		vigra_test
	fi
}
