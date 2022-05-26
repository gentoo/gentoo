# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit cmake fortran-2 python-any-r1 toolchain-funcs

DESCRIPTION="A three-dimensional finite element mesh generator"
HOMEPAGE="http://www.geuz.org/gmsh/"
SRC_URI="http://www.geuz.org/gmsh/src/${P}-source.tgz"

LICENSE="GPL-3 free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
## cgns is not compiling ATM, maybe fix cgns lib first
IUSE="blas cgns examples jpeg med metis mpi netgen opencascade petsc png python shared X zlib"

REQUIRED_USE="med? ( mpi )"

RDEPEND="
	virtual/fortran
	X? ( x11-libs/fltk:1[xft] )
	blas? ( virtual/blas virtual/lapack sci-libs/fftw:3.0 )
	cgns? ( sci-libs/cgnslib )
	jpeg? ( virtual/jpeg:0 )
	med? ( sci-libs/med[mpi] )
	opencascade? ( sci-libs/opencascade:* )
	png? ( media-libs/libpng:0 )
	petsc? ( sci-mathematics/petsc[mpi=] )
	zlib? ( sys-libs/zlib )
	mpi? ( virtual/mpi[cxx] )"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	python? ( dev-lang/swig:0 )
	"

S=${WORKDIR}/${P}-source

PATCHES=(
)

pkg_setup() {
	fortran-2_pkg_setup
}

src_configure() {
	local mycmakeargs=( )

	use blas && \
		mycmakeargs+=(-DCMAKE_Fortran_COMPILER=$(tc-getF77))

	local mycmakeargs+=(
		-DENABLE_BLAS_LAPACK="$(usex blas)"
		-DENABLE_BUILD_DYNAMIC="$(usex shared)"
		-DENABLE_CGNS="$(usex cgns)"
		-DENABLE_FLTK="$(usex X)"
		-DENABLE_GRAPHICS="$(usex X)"
		-DENABLE_MED="$(usex med)"
		-DENABLE_MPI="$(usex mpi)"
		-DENABLE_METIS="$(usex metis)"
		-DENABLE_NETGEN="$(usex netgen)"
		-DENABLE_OCC="$(usex opencascade)"
		-DENABLE_PETSC="$(usex petsc)"
		-DENABLE_WRAP_PYTHON="$(usex python)")

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use examples ; then
		dodoc -r demos tutorial
		docompress -x /usr/share/doc/${PF}/{demos,tutorial}
	fi
}
