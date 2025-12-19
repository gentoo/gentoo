# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib toolchain-funcs

Sparse_PV="7.0.0"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Sparse Cholesky factorization and update/downdate library"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

LICENSE="LGPL-2.1+ modify? ( GPL-2+ ) matrixops? ( GPL-2+ )"
SLOT="0/4"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+cholesky cuda doc openmp +matrixops +modify +partition +supernodal test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}
	>=sci-libs/amd-3.0.3
	>=sci-libs/colamd-3.0.3
	supernodal? ( virtual/lapack )
	partition? (
		>=sci-libs/camd-3.0.3
		>=sci-libs/ccolamd-3.0.3
	)
	cuda? (
		dev-util/nvidia-cuda-toolkit
		x11-drivers/nvidia-drivers
	)"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

REQUIRED_USE="supernodal? ( cholesky )
	modify? ( cholesky )
	test? ( cholesky matrixops supernodal )"

S="${WORKDIR}/${Sparse_P}/${PN^^}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

multilib_src_configure() {
	# Not that "N" prefixed options are negative options
	# so they need to be turned OFF if you want that option.
	# Fortran is turned off as it is only used to compile (untested) demo programs.
	local mycmakeargs=(
		-DNSTATIC=ON
		-DENABLE_CUDA=$(usex cuda)
		-DNOPENMP=$(usex openmp OFF ON)
		-DNFORTRAN=ON
		-DNCHOLESKY=$(usex cholesky OFF ON)
		-DNMATRIXOPS=$(usex matrixops OFF ON)
		-DNMODIFY=$(usex modify OFF ON)
		-DNPARTITION=$(usex partition OFF ON)
		-DNSUPERNODAL=$(usex supernodal OFF ON)
		-DDEMO=$(usex test)
	)
	cmake_src_configure
}

multilib_src_test() {
	# Run demo files
	./cholmod_demo   < "${S}"/Demo/Matrix/bcsstk01.tri || die "failed testing"
	./cholmod_l_demo < "${S}"/Demo/Matrix/bcsstk01.tri || die "failed testing"
	./cholmod_demo   < "${S}"/Demo/Matrix/lp_afiro.tri || die "failed testing"
	./cholmod_l_demo < "${S}"/Demo/Matrix/lp_afiro.tri || die "failed testing"
	./cholmod_demo   < "${S}"/Demo/Matrix/can___24.mtx || die "failed testing"
	./cholmod_l_demo < "${S}"/Demo/Matrix/can___24.mtx || die "failed testing"
	./cholmod_demo   < "${S}"/Demo/Matrix/c.tri || die "failed testing"
	./cholmod_l_demo < "${S}"/Demo/Matrix/c.tri || die "failed testing"
	./cholmod_simple < "${S}"/Demo/Matrix/c.tri || die "failed testing"
	./cholmod_simple < "${S}"/Demo/Matrix/can___24.mtx || die "failed testing"
	./cholmod_simple < "${S}"/Demo/Matrix/bcsstk01.tri || die "failed testing"
}

multilib_src_install() {
	if use doc; then
		pushd "${S}/Doc"
		rm -rf *.pdf
		emake
		popd
		DOCS="${S}/Doc/*.pdf"
	fi
	cmake_src_install
}
