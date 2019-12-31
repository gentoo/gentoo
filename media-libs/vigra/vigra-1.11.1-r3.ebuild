# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="threads(+),xml"
inherit cmake-utils python-r1

DESCRIPTION="C++ computer vision library emphasizing customizable algorithms and structures"
HOMEPAGE="https://ukoethe.github.io/vigra/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ukoethe/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ukoethe/${PN}/releases/download/Version-${PV//\./-}/${P}-src.tar.gz"
	KEYWORDS="amd64 arm64 ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc +fftw +hdf5 +jpeg mpi openexr +png +python test +tiff valgrind +zlib"

REQUIRED_USE="
	python? ( hdf5 ${PYTHON_REQUIRED_USE} )
	test? ( hdf5 python fftw )"

BDEPEND="
	test? (
		>=dev-python/nose-1.1.2-r1[${PYTHON_USEDEP}]
		valgrind? ( dev-util/valgrind )
	)
"
# runtime dependency on python is required by the vigra-config script
DEPEND="
	fftw? ( sci-libs/fftw:3.0 )
	hdf5? ( >=sci-libs/hdf5-1.8.0:=[mpi=] )
	jpeg? ( virtual/jpeg:0 )
	openexr? (
		media-libs/ilmbase:=
		media-libs/openexr:=
	)
	png? ( media-libs/libpng:0= )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost:=[python?,${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	tiff? ( media-libs/tiff:0= )
	zlib? ( sys-libs/zlib )
"
RDEPEND="${PYTHON_DEPS}
	${DEPEND}
"

# Severely broken, also disabled in Fedora, bugs #390447, #653442
RESTRICT="test"

PATCHES=(
	# git master
	"${FILESDIR}/${P}-fix-incorrect-template-parameter-type.patch"
	"${FILESDIR}/${P}-boost-python.patch"
	"${FILESDIR}/${P}-python3.7.patch" # bug 701208
	# TODO: upstream
	"${FILESDIR}/${P}-lib_suffix.patch"
	"${FILESDIR}/${P}-cmake-module-dir.patch"
	"${FILESDIR}/${P}-sphinx.ext.pngmath.patch" # thanks to Debian; bug 678308
)

pkg_setup() {
	use python && python_setup
}

src_prepare() {
	vigra_disable() {
		if ! use ${1}; then
			sed -e "/^VIGRA_FIND_PACKAGE.*${2:-$1}/Is/^/#disabled by USE=${1}: /" \
				-i CMakeLists.txt || die "failed to disable ${1}"
		fi
	}

	cmake-utils_src_prepare

	vigra_disable fftw fftw3
	vigra_disable fftw fftw3f
	vigra_disable jpeg
	vigra_disable png
	vigra_disable tiff
	vigra_disable zlib

	# Don't use python_fix_shebang because we can't put this behind USE="python"
	sed -i -e '/env/s:python:python3:' config/vigra-config.in || die

	use doc || cmake_comment_add_subdirectory docsrc

	if ! use test; then
		cmake_comment_add_subdirectory test
		sed -e "/ADD_SUBDIRECTORY.*test/s/^/#DONT /" -i vigranumpy/CMakeLists.txt || die
	fi
}

src_configure() {
	vigra_configure() {
		local mycmakeargs=(
			-DAUTOEXEC_TESTS=OFF
			-DDOCINSTALL="share/doc/${PF}/html"
			-DWITH_HDF5=$(usex hdf5)
			-DWITH_OPENEXR=$(usex openexr)
			-DWITH_VALGRIND=$(usex valgrind)
			-DWITH_VIGRANUMPY=$(usex python)
		)
		cmake-utils_src_configure
	}

	if use python; then
		python_foreach_impl vigra_configure
	else
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
