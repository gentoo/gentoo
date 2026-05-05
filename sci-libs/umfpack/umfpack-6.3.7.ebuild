# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

Sparse_PV="7.12.2"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Unsymmetric multifrontal sparse LU factorization library"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

S="${WORKDIR}/${Sparse_P}/${PN^^}"
LICENSE="GPL-2+"
SLOT="0/6"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc openmp test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}
	>=sci-libs/amd-3.3.4
	>=sci-libs/cholmod-5.3.4[openmp=]
	virtual/blas"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	# Fortran is only used to compile additional demo programs that can be tested.
	# Define SUITESPARSE_INCLUDEDIR_POSTFIX to "" otherwise it take
	# the value suitesparse, and the include directory would be set to
	# /usr/include/suitesparse
	# This need to be set in all suitesparse ebuilds.
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=OFF
		-DSUITESPARSE_USE_OPENMP=$(usex openmp)
		-DSUITESPARSE_USE_FORTRAN=OFF
		-DSUITESPARSE_DEMOS=$(usex test)
		-DSUITESPARSE_INCLUDEDIR_POSTFIX=""
	)
	cmake_src_configure
}

src_test() {
	# Because we are not using cmake_src_test,
	# we have to manually go to BUILD_DIR
	cd "${BUILD_DIR}" || die
	# Run demo files
	# Other demo files have issues making them unsuitable for testing
	./umfpack_simple || die "failed testing umfpack_simple"
	einfo "All tests passed"
}

src_install() {
	if use doc; then
		pushd "${S}/Doc" || die
		emake clean
		rm -rf *.pdf || die
		emake
		popd || die
		DOCS="${S}/Doc/*.pdf"
	fi
	cmake_src_install
}
