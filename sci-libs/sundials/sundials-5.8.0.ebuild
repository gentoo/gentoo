# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
FORTRAN_NEEDED=fortran
FORTRAN_STANDARD="77 90 2003"
# if FFLAGS and FCFLAGS are set then should be equal

inherit cmake flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="Suite of nonlinear solvers"
HOMEPAGE="https://computation.llnl.gov/projects/sundials"
SRC_URI="https://github.com/LLNL/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples fortran hypre lapack mpi openmp sparse +static-libs superlumt threads"
REQUIRED_USE="
	fortran? ( static-libs )
	hypre? ( mpi )
"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	lapack? ( virtual/lapack )
	mpi? (
		sci-libs/hypre:=[fortran?,mpi?]
		virtual/mpi[fortran?]
	)
	sparse? ( sci-libs/klu )
	superlumt? ( sci-libs/superlu_mt:= )
"
DEPEND="${RDEPEND}"

PATCHES=(
		"${FILESDIR}"/${P}-fix-license-install-path.patch
)

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp && [[ $(tc-getCC) == *gcc ]] && ! tc-has-openmp; then
		ewarn "OpenMP is not available in your current selected gcc"
		die "need openmp capable gcc"
	fi
}

src_prepare() {
	# bug #707240
	append-cflags -fcommon
	use threads && append-ldflags -pthread

	cmake_src_prepare
}

src_configure() {
	mycmakeargs+=(
		-DBUILD_FORTRAN77_INTERFACE=$(usex fortran)
		-DBUILD_FORTRAN_MODULE_INTERFACE=$(usex fortran)
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DENABLE_HYPRE=$(usex hypre)
		-DENABLE_KLU=$(usex sparse)
		-DENABLE_LAPACK=$(usex lapack)
		-DENABLE_MPI=$(usex mpi)
		-DENABLE_OPENMP=$(usex openmp)
		-DENABLE_PTHREAD=$(usex threads)
		-DENABLE_SUPERLUMT=$(usex superlumt)
		-DEXAMPLES_INSTALL=ON
		-DEXAMPLES_INSTALL_PATH="/usr/share/doc/${PF}/examples"
		-DSUPERLUMT_INCLUDE_DIR="${EPREFIX}/usr/include/superlu_mt"
		-DSUPERLUMT_LIBRARY="-lsuperlu_mt"
		-DUSE_GENERIC_MATH=ON
	)
	if use examples; then
		mycmakeargs+=(
			-DEXAMPLES_ENABLE_C=ON
			-DEXAMPLES_ENABLE_CXX=ON
		)
		if use fortran; then
			mycmakeargs+=(
				-DEXAMPLES_ENABLE_F77=ON
				-DEXAMPLES_ENABLE_F90=ON
				-DEXAMPLES_ENABLE_F2003=ON
			)
		fi
	fi

	if use fortran; then
		mycmakeargs+=(
			-DFortran_INSTALL_MODDIR="${EPREFIX}/usr/$(get_libdir)/fortran"
		)
	fi

	if use hypre; then
		mycmakeargs+=(
			-DHYPRE_INCLUDE_DIR="${EPREFIX}/usr/include/hypre"
			-DHYPRE_LIBRARY="${EPREFIX}/usr/$(get_libdir)/libHYPRE.so"
		)
	fi

	if use sparse; then
		mycmakeargs+=(
		-DKLU_LIBRARY="${EPREFIX}/usr/$(get_libdir)/libklu.so"
		)
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use doc && dodoc doc/*/*.pdf
}
