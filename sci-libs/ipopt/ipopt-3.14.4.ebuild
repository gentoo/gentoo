# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED="mumps"
DOCS_BUILDER="doxygen"
DOCS_DIR="doc"
DOCS_DEPEND="media-gfx/graphviz"

inherit docs fortran-2 toolchain-funcs

DESCRIPTION="Interior-Point Optimizer for large-scale nonlinear optimization"
HOMEPAGE="https://github.com/coin-or/Ipopt"
SRC_URI="https://github.com/coin-or/Ipopt/archive/refs/tags/releases/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Ipopt-releases-${PV}"

LICENSE="EPL-1.0 hsl? ( HSL )"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="hsl +lapack mpi mumps static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/blas
	hsl? ( sci-libs/coinhsl:0= )
	lapack? ( virtual/lapack )
	mpi? ( virtual/mpi )
	mumps? ( sci-libs/mumps:0=[mpi=] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( sci-libs/coinor-sample sci-libs/mumps )"

src_prepare() {
	if use mpi ; then
		export CXX=mpicxx FC=mpif77 F77=mpif77 CC=mpicc
	fi
	default
}

src_configure() {
	local myeconfargs=(
		$(use_with doc dot)
	)

	if use lapack; then
		myeconfargs+=( --with-lapack="$($(tc-getPKG_CONFIG) --libs blas lapack)" )
	else
		myeconfargs+=( --without-lapack )
	fi
	if use mumps; then
		myeconfargs+=(
			--with-mumps-incdir="${EPREFIX}"/usr/include$(usex mpi '' '/mpiseq')
			--with-mumps-lib="-lmumps_common -ldmumps -lzmumps -lsmumps -lcmumps" )
	else
		myeconfargs+=( --without-mumps )
	fi
	if use hsl; then
		myeconfargs+=(
			--with-hsl-incdir="${EPREFIX}"/usr/include
			--with-hsl-lib="$($(tc-getPKG_CONFIG) --libs coinhsl)" )
	else
		myeconfargs+=( --without-hsl )
	fi
	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	docs_compile
}

src_install() {
	default
	dodoc -r examples
}
