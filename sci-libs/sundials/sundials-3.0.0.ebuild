# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FORTRAN_NEEDED=fortran
FORTRAN_STANDARD=90

inherit cmake-utils toolchain-funcs fortran-2 versionator

DESCRIPTION="Suite of nonlinear solvers"
HOMEPAGE="https://computation.llnl.gov/projects/sundials"
SRC_URI="https://computation.llnl.gov/projects/sundials/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/$(get_major_version)"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cxx doc examples fortran hypre lapack mpi openmp sparse static-libs superlumt threads"
REQUIRED_USE="hypre? ( mpi )"

RDEPEND="
	lapack? ( virtual/lapack )
	mpi? ( virtual/mpi sci-libs/hypre:= )
	sparse? ( sci-libs/klu:= )
	superlumt? ( sci-libs/superlu_mt:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( )

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp && [[ $(tc-getCC) == *gcc ]] && ! tc-has-openmp; then
		ewarn "OpenMP is not available in your current selected gcc"
		die "need openmp capable gcc"
	fi
}

src_configure() {
	mycmakeargs+=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_STATIC_LIBS="$(usex static-libs)"
		-DCXX_ENABLE="$(usex cxx)"
		-DFCMIX_ENABLE="$(usex fortran)"
		-DF90_ENABLE="$(usex fortran)"
		-DHYPRE_ENABLE="$(usex hypre)"
		-DHYPRE_INCLUDE_DIR="${EPREFIX}/usr/include/hypre"
		-DHYPRE_LIBRARY="HYPRE"
		-DKLU_ENABLE="$(usex sparse)"
		-DKLU_LIBRARY="${EPREFIX}/usr/$(get_libdir)/libklu.so"
		-DLAPACK_ENABLE="$(usex lapack)"
		-DMPI_ENABLE="$(usex mpi)"
		-DOPENMP_ENABLE="$(usex openmp)"
		-DPTHREAD_ENABLE="$(usex threads)"
		-DSUPERLUMT_ENABLE="$(usex superlumt)"
		-DSUPERLUMT_INCLUDE_DIR="${EPREFIX}/usr/include/superlu_mt"
		-DSUPERLUMT_LIBRARY="superlu_mt"
		-DEXAMPLES_ENABLE="$(usex examples)"
		-DEXAMPLES_INSTALL=ON
		-DEXAMPLES_INSTALL_PATH="/usr/share/doc/${PF}/examples"
		-DUSE_GENERIC_MATH=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	use doc && dodoc doc/*/*.pdf
	cd src
	for r in */README; do
		newdoc ${r} README-${r%/*}
	done

	# Use a sledgehammer, patching the buildsystem is too annoyoing (the
	# CMake build systems consists of 2000 "lib" DESTINATIONS...)
	if [[ lib != $(get_libdir) ]]; then
		mv "${ED%/}"/usr/lib "${ED%/}"/usr/$(get_libdir) || die
	fi
}
