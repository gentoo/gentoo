# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="threads(+),xml(+)"

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="C++ computer vision library emphasizing customizable algorithms and structures"
HOMEPAGE="https://ukoethe.github.io/vigra/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ukoethe/${PN}.git"
	inherit git-r3
else
	if [[ ${PV} == *_p* ]] ; then
		VIGRA_COMMIT="4db795574a471bf1d94d258361f1ef536dd87ac1"
		SRC_URI="https://github.com/ukoethe/vigra/archive/${VIGRA_COMMIT}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}"/${PN}-${VIGRA_COMMIT}
	else
		SRC_URI="https://github.com/ukoethe/${PN}/releases/download/Version-${PV//\./-}/${P}-src.tar.gz"
	fi

	KEYWORDS="~amd64 ~arm64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-solaris"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+fftw +hdf5 +jpeg mpi openexr +png test +tiff +zlib"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	test? ( hdf5 fftw )
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="
	fftw? ( sci-libs/fftw:3.0= )
	hdf5? ( >=sci-libs/hdf5-1.8.0:=[mpi=] )
	jpeg? ( media-libs/libjpeg-turbo:= )
	openexr? (
		>=dev-libs/imath-3.1.4-r2:=
		>=media-libs/openexr-3:0=
	)
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:= )
	zlib? ( sys-libs/zlib )
"
# Python is needed as a runtime dep of installed vigra-config
RDEPEND="
	${PYTHON_DEPS}
	${DEPEND}
"

# Severely broken, also disabled in Fedora, bugs #390447, #653442
RESTRICT="test"

PATCHES=(
	# TODO: upstream
	"${FILESDIR}/${PN}-1.11.1-lib_suffix.patch"
	"${FILESDIR}/${PN}-1.11.1-cmake-module-dir.patch"
)

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

	sed -i -e '/ADD_DEPENDENCIES(PACKAGE_SRC_TAR doc_cpp)/d' CMakeLists.txt || die

	cmake_comment_add_subdirectory docsrc

	if ! use test; then
		cmake_comment_add_subdirectory test
		cmake_run_in vigranumpy cmake_comment_add_subdirectory test
	fi
}

src_configure() {
	# Needed for now ("fix" compatibility with >=sci-libs/hdf5-1.12)
	# bug #808731
	use hdf5 && append-cppflags -DH5_USE_110_API

	local mycmakeargs=(
		-DAUTOEXEC_TESTS=OFF
		-DDOCINSTALL="share/doc/${PF}/html"
		-DWITH_HDF5=$(usex hdf5)
		-DWITH_OPENEXR=$(usex openexr)
		-DWITH_VALGRIND=OFF # only used for tests
		-DWITH_VIGRANUMPY=OFF
	)

	cmake_src_configure
}

src_test() {
	PYTHONPATH="${BUILD_DIR}/vigranumpy/vigra" cmake_src_test
}
