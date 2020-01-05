# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit cmake-utils eutils toolchain-funcs fortran-2 python-r1

DESCRIPTION="Core libraries for the Common Astronomy Software Applications"
HOMEPAGE="https://github.com/casacore/casacore"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="+c++11 +data doc fftw hdf5 openmp python threads test"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	sci-astronomy/wcslib:0=
	sci-libs/cfitsio:0=
	sys-libs/readline:0=
	virtual/blas:=
	virtual/lapack:=
	data? ( sci-astronomy/casa-data )
	fftw? ( sci-libs/fftw:3.0= )
	hdf5? ( sci-libs/hdf5:0= )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost:0=[python,${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( sci-astronomy/casa-data	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.0-disable-class-and-collaboration-graph-generation.patch
	"${FILESDIR}"/${PN}-2.3.0-disable-known-test-failures.patch
	"${FILESDIR}"/${PN}-2.3.0-disable-tests-that-require-data-tables.patch
	"${FILESDIR}"/${PN}-2.3.0-do-not-install-test-and-demonstration-executables.patch
	"${FILESDIR}"/${PN}-2.3.0-fix-FTBFS-tStatisticsUtilities-tLatticeStatistics-and-tLC.patch
	"${FILESDIR}"/${PN}-2.3.0-fix-too-small-int-type-for-memory-on-32-bit-machines.patch
	"${FILESDIR}"/${PN}-2.3.0-loose-some-tests-tFFTServer-tests.patch
	"${FILESDIR}"/${PN}-2.3.0-make-the-check-for-NFS-a-bit-more-portable-BSD.patch
	"${FILESDIR}"/${PN}-2.3.0-use-the-correct-symbol-to-detect-Linux-OS.patch
)

pkg_pretend() {
	if [[ $(tc-getCC)$ == *gcc* ]] && [[ ${MERGE_TYPE} != binary ]]; then
		use c++11 && [[ $(gcc-major-version) -lt 4 ]] || \
			( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 ]] ) && \
				die "You are using gcc but gcc-4.7 or higher is required for C++11"
	fi
	use openmp && tc-check-openmp
}

src_prepare() {
	cmake-utils_src_prepare
	sed -e '/python-py/s/^.*$/find_package(Boost REQUIRED COMPONENTS python)/' \
		-i python3/CMakeLists.txt || die
}

src_configure() {
	has_version sci-libs/hdf5[mpi] && export CXX=mpicxx
	local mycmakeargs=(
		-DENABLE_SHARED=ON
		-DBUILD_PYTHON=OFF
		-DDATA_DIR="${EPREFIX}/usr/share/casa/data"
		-DBUILD_TESTING="$(usex test)"
		-DCXX11="$(usex c++11)"
		-DUSE_FFTW3="$(usex fftw)"
		-DUSE_HDF5="$(usex hdf5)"
		-DUSE_OPENMP="$(usex openmp)"
		-DUSE_THREADS="$(usex threads)"
	)
	python_set_options() {
		if python_is_python3; then
			mycmakeargs+=(
				-DPYTHON3_EXECUTABLE="${PYTHON}"
				-DBUILD_PYTHON3=ON
			)
		else
			mycmakeargs+=(
				-DPYTHON2_EXECUTABLE="${PYTHON}"
				-DBUILD_PYTHON=ON
			)
		fi
	}
	use python && python_foreach_impl python_set_options
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		doxygen doxygen.cfg || die
	fi
}

src_install(){
	cmake-utils_src_install
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r doc/html
		docompress -x /usr/share/doc/${PF}/html
	fi
}
