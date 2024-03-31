# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
FORTRAN_NEEDED=fortran
FORTRAN_STANDARD="77 90 2003"
# if FFLAGS and FCFLAGS are set then should be equal

inherit cmake flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="Suite of nonlinear solvers"
HOMEPAGE="https://computing.llnl.gov/projects/sundials"
SRC_URI="https://github.com/LLNL/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/$(ver_cut 1)"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples fortran hypre +int64 lapack mpi openmp sparse +static-libs superlumt threads"
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
	superlumt? ( sci-libs/superlu_mt:=[int64=] )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.8.0-fix-license-install-path.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	# bug #707240
	append-cflags -fcommon
	use threads && append-ldflags -pthread

	cmake_src_prepare
}

src_configure() {
	# undefined reference to `psolve'
	# undefined reference to `psetup'
	# https://bugs.gentoo.org/862933
	# https://github.com/LLNL/sundials/issues/97
	filter-lto

	mycmakeargs+=(
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
		-DSUNDIALS_INDEX_SIZE="$(usex int64 64 32)"
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
