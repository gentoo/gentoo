# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="threads(+),xml(+)"

inherit cmake flag-o-matic python-r1

DESCRIPTION="C++ computer vision library emphasizing customizable algorithms and structures"
HOMEPAGE="https://ukoethe.github.io/vigra/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ukoethe/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ukoethe/${PN}/releases/download/Version-${PV//\./-}/${P}-src.tar.gz"
	KEYWORDS="amd64 arm64 ~sparc x86 ~amd64-linux ~x86-linux ~x64-solaris"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc +fftw +hdf5 +jpeg mpi openexr +png +python test +tiff +zlib"

REQUIRED_USE="
	python? ( hdf5 ${PYTHON_REQUIRED_USE} )
	test? ( hdf5 python fftw )"

# runtime dependency on python is required by the vigra-config script
DEPEND="
	fftw? ( sci-libs/fftw:3.0= )
	hdf5? ( >=sci-libs/hdf5-1.8.0:=[mpi=] )
	jpeg? ( media-libs/libjpeg-turbo:= )
	openexr? (
		>=dev-libs/imath-3.1.4-r2:=
		>=media-libs/openexr-3:0=
	)
	png? ( media-libs/libpng:0= )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost:=[python?,${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	tiff? ( media-libs/tiff:= )
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
	"${FILESDIR}/${P}-gcc-10.patch" # bug 723302
	# TODO: upstream
	"${FILESDIR}/${P}-lib_suffix.patch"
	"${FILESDIR}/${P}-cmake-module-dir.patch"
	"${FILESDIR}/${P}-sphinx.ext.pngmath.patch" # thanks to Debian; bug 678308
	"${FILESDIR}/${P}-openexr3.patch"
	"${FILESDIR}/${P}-python-syntax.patch"
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

	cmake_src_prepare

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
		cmake_run_in vigranumpy cmake_comment_add_subdirectory test
	fi
}

src_configure() {
	# Needed for now ("fix" compatibility with >=sci-libs/hdf5-1.12)
	# bug #808731
	use hdf5 && append-cppflags -DH5_USE_110_API

	vigra_configure() {
		local mycmakeargs=(
			-DAUTOEXEC_TESTS=OFF
			-DDOCINSTALL="share/doc/${PF}/html"
			-DWITH_HDF5=$(usex hdf5)
			-DWITH_OPENEXR=$(usex openexr)
			-DWITH_VALGRIND=OFF # only used for tests
			-DWITH_VIGRANUMPY=$(usex python)
		)
		cmake_src_configure
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
		cmake_src_compile
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
		python_foreach_impl cmake_src_install
		python_optimize
	else
		cmake_src_install
	fi
}

src_test() {
	# perhaps disable tests (see #390447)
	vigra_test() {
		PYTHONPATH="${BUILD_DIR}/vigranumpy/vigra" cmake_src_test
	}
	if use python; then
		python_foreach_impl vigra_test
	else
		vigra_test
	fi
}
