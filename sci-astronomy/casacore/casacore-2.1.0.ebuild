# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# python3 is experimental and only one python is supported
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils eutils toolchain-funcs fortran-2 python-single-r1

DESCRIPTION="Core libraries for the Common Astronomy Software Applications"
HOMEPAGE="https://github.com/casacore/casacore"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="c++11 +data doc fftw hdf5 openmp python threads test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	sci-astronomy/wcslib:0=
	sci-libs/cfitsio:0=
	sys-libs/readline:0=
	virtual/blas
	virtual/lapack
	data? ( sci-astronomy/casa-data )
	fftw? ( sci-libs/fftw:3.0= )
	hdf5? ( sci-libs/hdf5:0= )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost:0=[python,${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( sci-astronomy/casa-data sci-astronomy/sofa_c )"

PATCHES=(
	"${FILESDIR}/${PN}-disable-tpath-test.patch"
	"${FILESDIR}/${PN}-2.1.0-fix-c++14.patch"
)

pkg_pretend() {
	if [[ $(tc-getCC)$ == *gcc* ]] && [[ ${MERGE_TYPE} != binary ]]; then
		use c++11 && [[ $(gcc-major-version) -lt 4 ]] || \
		( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 ]] ) && \
			die "You are using gcc but gcc-4.7 or higher is required for C++11"
		use openmp && ! tc-has-openmp && \
			die "You are using gcc but without OpenMP capabilities that you requested"
	fi
}

pkg_setup() {
	use python && python-single-r1_pkg_setup
	fortran-2_pkg_setup
}

src_configure() {
	has_version sci-libs/hdf5[mpi] && export CXX=mpicxx
	local mycmakeargs=(
		-DENABLE_SHARED=ON
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DDATA_DIR="${EPREFIX}/usr/share/casa/data"
		-DBUILD_PYTHON="$(usex python)"
		-DBUILD_TESTING="$(usex test)"
		-DCXX11="$(usex c++11)"
		-DUSE_FFTW3="$(usex fftw)"
		-DUSE_HDF5="$(usex hdf5)"
		-DUSE_OPENMP="$(usex openmp)"
		-DUSE_THREADS="$(usex threads)"
	)
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
	fi
}
