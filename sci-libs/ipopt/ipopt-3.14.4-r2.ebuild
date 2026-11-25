# Copyright 1999-2026 Gentoo Authors
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

LICENSE="EPL-1.0"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"
IUSE="+asl +lapack mpi mumps static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/blas
	asl? ( sci-libs/coinasl:0= )
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
		--disable-java
		$(use_with doc dot)
		$(use_with asl)
		--without-hsl
	)

	if use lapack; then
		myeconfargs+=( --with-lapack="$($(tc-getPKG_CONFIG) --libs blas lapack)" )
	else
		myeconfargs+=( --without-lapack )
	fi
	if use mumps; then
		myeconfargs+=(
			--with-mumps-cflags=-I"${EPREFIX}"/usr/include$(usex mpi '' '/mpiseq')
			--with-mumps-lflags="-lmumps_common -ldmumps -lzmumps -lsmumps -lcmumps" )
	else
		myeconfargs+=( --without-mumps )
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

	if ! use static-libs; then
		find "${ED}" -name '*.la' -exec rm -f {} + || die
	fi
}
