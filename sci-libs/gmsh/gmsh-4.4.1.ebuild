# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils flag-o-matic fortran-2 python-any-r1 toolchain-funcs

DESCRIPTION="A three-dimensional finite element mesh generator"
HOMEPAGE="http://www.geuz.org/gmsh/"
SRC_URI="http://www.geuz.org/gmsh/src/${P}-source.tgz"

LICENSE="GPL-3 free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
## cgns is not compiling ATM, maybe fix cgns lib first
IUSE="blas cgns examples jpeg lua med metis mpi netgen opencascade petsc png python X zlib"

REQUIRED_USE="med? ( mpi )"

RDEPEND="
	virtual/fortran
	X? ( x11-libs/fltk:1 )
	blas? ( virtual/blas virtual/lapack sci-libs/fftw:3.0 )
	cgns? ( sci-libs/cgnslib )
	jpeg? ( virtual/jpeg:0 )
	lua? ( dev-lang/lua:0 )
	med? ( sci-libs/med )
	opencascade? ( sci-libs/opencascade:* )
	png? ( media-libs/libpng:0 )
	petsc? ( sci-mathematics/petsc )
	zlib? ( sys-libs/zlib )
	mpi? ( virtual/mpi[cxx] )"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	python? ( dev-lang/swig:0 )
	"

S=${WORKDIR}/${P}-source

pkg_setup() {
	fortran-2_pkg_setup
}

src_configure() {
	local mycmakeargs=( )

	use blas && \
		mycmakeargs+=(-DCMAKE_Fortran_COMPILER=$(tc-getF77))

	mycmakeargs+=(
		-DENABLE_BLAS_LAPACK="$(usex blas)"
		-DENABLE_CGNS="$(usex cgns)"
		-DENABLE_FLTK="$(usex X)"
		-DENABLE_GRAPHICS="$(usex X)"
		-DENABLE_MED="$(usex med)"
		-DENABLE_METIS="$(usex metis)"
		-DENABLE_NETGEN="$(usex netgen)"
		-DENABLE_OCC="$(usex opencascade)"
		-DENABLE_PETSC="$(usex petsc)"
		-DENABLE_WRAP_PYTHON="$(usex python)")

	cmake-utils_src_configure mycmakeargs
}

src_install() {
	cmake-utils_src_install

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r demos tutorial
	fi
}
