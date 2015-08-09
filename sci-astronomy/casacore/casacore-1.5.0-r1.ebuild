# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils eutils toolchain-funcs fortran-2

DESCRIPTION="Core libraries for the Common Astronomy Software Applications"
HOMEPAGE="http://code.google.com/p/casacore/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
#KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
# de-keyworded until casa-data catches up
KEYWORDS=""
SLOT="0"
IUSE="+data doc fftw hdf5 openmp threads test"

RDEPEND="
	sci-libs/cfitsio:0=
	sci-astronomy/wcslib:0=
	sys-libs/readline:0=
	virtual/blas
	virtual/lapack
	data? ( sci-astronomy/casa-data )
	fftw? ( sci-libs/fftw:3.0= )
	hdf5? ( sci-libs/hdf5:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( sci-astronomy/casa-data )"

PATCHES=(
	"${FILESDIR}"/1.3.0-implicits.patch
	"${FILESDIR}"/1.3.0-libdir.patch
	"${FILESDIR}"/1.5.0-sysdep.patch
	"${FILESDIR}"/1.5.0-gcc47.patch
	"${FILESDIR}"/1.5.0-gcc48.patch
)

pkg_setup() {
	if use openmp && [[ $(tc-getCC)$ == *gcc* ]] && ! tc-has-openmp; then
		ewarn "You are using gcc but without OpenMP capabilities"
		die "Need an OpenMP capable compiler"
	fi
	fortran-2_pkg_setup
}

src_configure() {
	has_version sci-libs/hdf5[mpi] && export CXX=mpicxx
	local mycmakeargs=(
		-DENABLE_SHARED=ON
		-DDATA_DIR="${EPREFIX}/usr/share/casa/data"
		$(cmake-utils_use_build test TESTING)
		$(cmake-utils_use_use fftw FFTW3)
		$(cmake-utils_use_use hdf5 HDF5)
		$(cmake-utils_use_use threads THREADS)
		$(cmake-utils_use_use openmp OPENMP)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && doxygen doxygen.cfg
}

src_install(){
	cmake-utils_src_install
	use doc && dohtml -r doc/html/*
}
