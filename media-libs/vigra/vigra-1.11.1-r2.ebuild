# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P}-src"
MY_V="${PV//\./-}"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads,xml"
inherit cmake-utils python-r1

DESCRIPTION="C++ computer vision library emphasizing customizable algorithms and structures"
HOMEPAGE="https://ukoethe.github.io/vigra/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ukoethe/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ukoethe/${PN}/releases/download/Version-${MY_V}/${MY_P}.tar.gz"
	KEYWORDS="amd64 arm64 ~sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc +fftw +hdf5 +jpeg mpi openexr +png +python test +tiff valgrind +zlib"

REQUIRED_USE="
	doc? ( hdf5 fftw ${PYTHON_REQUIRED_USE} )
	python? ( hdf5 ${PYTHON_REQUIRED_USE} )
	test? ( hdf5 python fftw )"

BDEPEND="
	doc? (
		app-doc/doxygen
		>=dev-python/sphinx-1.1.3-r5
	)
	test? (
		>=dev-python/nose-1.1.2-r1[${PYTHON_USEDEP}]
		valgrind? ( dev-util/valgrind )
	)
"
# runtime dependency on python:2.7 is required by the vigra-config script
DEPEND="
	dev-lang/python:2.7
	fftw? ( sci-libs/fftw:3.0 )
	hdf5? ( >=sci-libs/hdf5-1.8.0:=[mpi=] )
	jpeg? ( virtual/jpeg:0 )
	openexr? (
		media-libs/openexr:=
		media-libs/ilmbase:=
	)
	png? ( media-libs/libpng:0= )
	python? (
		dev-libs/boost:=[python?,${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
	tiff? ( media-libs/tiff:0= )
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}"

# Severely broken, also disabled in Fedora, bugs #390447, #653442
RESTRICT="test"

PATCHES=(
	# git master
	"${FILESDIR}/${P}-fix-incorrect-template-parameter-type.patch"
	"${FILESDIR}/${P}-boost-python.patch"
	# TODO: upstream
	"${FILESDIR}/${P}-lib_suffix.patch"
)

pkg_setup() {
	if use python || use doc; then
		python_setup
	fi
}

src_prepare() {
	vigra_disable() {
		if ! use ${1}; then
			sed -e "/^VIGRA_FIND_PACKAGE.*${2:-$1}/Is/^/#disabled by USE=${1}: /" \
				-i CMakeLists.txt || die "failed to disable ${1}"
		fi
	}

	cmake-utils_src_prepare

	if [[ ${PV} != *9999 ]]; then
		rm -r doc || die "failed to remove shipped docs"
	fi

	vigra_disable fftw fftw3
	vigra_disable fftw fftw3f
	vigra_disable jpeg
	vigra_disable png
	vigra_disable tiff
	vigra_disable zlib

	# Don't use python_fix_shebang because we can't put this behind USE="python"
	sed -i -e '/env/s:python:python2:' config/vigra-config.in || die
}

src_configure() {
	vigra_configure() {
		local mycmakeargs=(
			-DAUTOEXEC_TESTS=OFF
			-DDOCDIR="${BUILD_DIR}/doc"
			-DDOCINSTALL="share/doc/${PF}"
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
		VARTEXFONTS="${T}/fonts" BUILD_DIR="${VIGRA_BUILD_DIR}" cmake-utils_src_make doc
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
