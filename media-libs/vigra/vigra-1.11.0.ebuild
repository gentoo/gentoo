# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
MY_P=${P}-src
MY_V=${PV//\./-}
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads,xml"
inherit cmake-utils python-r1

DESCRIPTION="C++ computer vision library with emphasis on customizable algorithms and data structures"
HOMEPAGE="http://hci.iwr.uni-heidelberg.de/vigra/"
SRC_URI="https://github.com/ukoethe/vigra/releases/download/Version-${MY_V}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc +fftw +hdf5 +jpeg mpi openexr +png +python test +tiff valgrind"

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
	tiff? ( media-libs/tiff:0= )
	valgrind? ( dev-util/valgrind )"

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

DOCS=( README.md )

pkg_setup() {
	use python && python_setup
}

src_prepare() {
	default

	einfo "Removing shipped docs and VCS files"
	rm -rf doc || die
	rm .git* .travis.yml || die

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
			-DUSE_DOC=$(usex doc ON OFF) # unused
			-DUSE_FFTW3=$(usex fftw ON OFF) # unused
			-DUSE_JPEG=$(usex jpeg ON OFF) # unused
			-DUSE_MPI=$(usex mpi ON OFF) # unused
			-DUSE_PNG=$(usex png ON OFF) # unused
			-DUSE_TIFF=$(usex tiff ON OFF) # unused
			-DWITH_HDF5=$(usex hdf5 ON OFF)
			-DWITH_OPENEXR=$(usex openexr ON OFF)
			-DWITH_VALGRIND=$(usex valgrind ON OFF)
			-DWITH_VIGRANUMPY=$(usex python ON OFF)
			-DBUILD_TESTING=$(usex test ON OFF) # unused
			-DUSE_AUTOBUILD_TESTS=$(usex test ON OFF) # unused
			-DUSE_CREATE_CTEST_TARGETS=$(usex test ON OFF) # unused
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
