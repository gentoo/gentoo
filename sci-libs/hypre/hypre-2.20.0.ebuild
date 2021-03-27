# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_NEEDED=fortran

inherit fortran-2 toolchain-funcs flag-o-matic

DESCRIPTION="Parallel matrix preconditioners library"
HOMEPAGE="https://computation.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
SRC_URI="https://github.com/${PN}-space/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug examples fortran int64 openmp mpi"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	sci-libs/superlu:=
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}"

DOCS=( CHANGELOG COPYRIGHT README )

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp && [[ $(tc-getCC) == *gcc* ]] ; then
		tc-check-openmp
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp && [[ $(tc-getCC) == *gcc* ]] && ! tc-has-openmp ; then
		ewarn "You are using a non capable gcc compiler ( < 4.2 ? )"
		die "Need an OpenMP capable compiler"
	fi
}

src_prepare() {
	default

	# link with system superlu and propagate LDFLAGS
	sed -e "s:@LIBS@:@LIBS@ $($(tc-getPKG_CONFIG) --libs superlu):" \
		-e 's:_SHARED@:_SHARED@ $(LDFLAGS):g' \
		-i src/config/Makefile.config.in || die

	sed -e '/HYPRE_ARCH/s: = :=:g' \
		-i src/configure || die

	# link with system blas and lapack
	sed -e '/^BLASFILES/d' \
		-e '/^LAPACKFILES/d' \
		-i src/lib/Makefile || die
}

src_configure() {
	tc-export CC CXX
	append-flags -Dhypre_dgesvd=dgesvd_

	if use openmp && [[ $(tc-getCC) == *gcc* ]] ; then
		append-flags -fopenmp && append-ldflags -fopenmp
	fi

	if use mpi ; then
		CC=mpicc
		FC=mpif77
		CXX=mpicxx
	fi

	cd src || die

	# without-superlu: means do not use bundled one
	econf \
		--enable-shared \
		--with-blas-libs="$($(tc-getPKG_CONFIG) --libs-only-l blas | sed -e 's/-l//g')" \
		--with-blas-lib-dirs="$($(tc-getPKG_CONFIG) --libs-only-L blas | sed -e 's/-L//g')" \
		--with-lapack-libs="$($(tc-getPKG_CONFIG) --libs-only-l lapack | sed -e 's/-l//g')" \
		--with-lapack-lib-dirs="$($(tc-getPKG_CONFIG) --libs-only-L lapack | sed -e 's/-L//g')" \
		--with-timing \
		--without-superlu \
		$(use_enable debug) \
		$(use_enable openmp hopscotch) \
		$(use_enable int64 bigint) \
		$(use_enable fortran) \
		$(use_with openmp) \
		$(use_with mpi MPI)
}

src_compile() {
	emake -C src
}

src_test() {
	LD_LIBRARY_PATH="${S}/src/lib:${LD_LIBRARY_PATH}" \
				   PATH="${S}/src/test:${PATH}" \
				   emake -C src check
}

src_install() {
	emake -C src install \
		  HYPRE_INSTALL_DIR="${ED}" \
		  HYPRE_LIB_INSTALL="${ED}/usr/$(get_libdir)" \
		  HYPRE_INC_INSTALL="${ED}/usr/include/hypre"

	if use examples; then
		dodoc -r src/examples
	fi
}
