# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

Sparse_PV="7.12.2"
Sparse_P="SuiteSparse-${Sparse_PV}"
inherit cmake cuda toolchain-funcs

DESCRIPTION="Sparse Cholesky factorization and update/downdate library"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"
S="${WORKDIR}/${Sparse_P}/${PN^^}"

LICENSE="LGPL-2.1+ modify? ( GPL-2+ ) matrixops? ( GPL-2+ )"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+cholesky cuda doc openmp +matrixops +modify +partition +supernodal test"
RESTRICT="!test? ( test )"

DEPEND="
	>=sci-libs/suitesparseconfig-${Sparse_PV}:=
	>=sci-libs/amd-3.3.4:=
	>=sci-libs/colamd-3.3.5:=
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
		x11-drivers/nvidia-drivers
	)
	partition? (
		>=sci-libs/camd-3.3.5:=
		>=sci-libs/ccolamd-3.3.5:=
	)
	supernodal? (
		virtual/lapack
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? ( virtual/latex-base )
"

REQUIRED_USE="
	supernodal? ( cholesky )
	modify? ( cholesky )
	test? ( cholesky matrixops supernodal )
"

PATCHES=( "${FILESDIR}"/${P}-{metis,gklib}-cmake4.patch ) # bug 957609

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cmake_src_prepare

	if use cuda; then
		cuda_src_prepare
	fi
}

src_configure() {
	# Note that "N" prefixed options are negative options
	# so, they need to be turned OFF if you want that option.
	# Fortran is turned off as it is only used to compile (untested) demo programs.
	# Define SUITESPARSE_INCLUDEDIR_POSTFIX to "" otherwise it take
	# the value suitesparse, and the include directory would be set to
	# /usr/include/suitesparse
	# This need to be set in all suitesparse ebuilds.
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=OFF
		-DCHOLMOD_USE_CUDA=$(usex cuda)
		-DCHOLMOD_USE_OPENMP=$(usex openmp)
		-DSUITESPARSE_HAS_FORTRAN=OFF
		-DCHOLMOD_CHOLESKY=$(usex cholesky)
		-DCHOLMOD_MATRIXOPS=$(usex matrixops)
		-DCHOLMOD_MODIFY=$(usex modify)
		-DCHOLMOD_PARTITION=$(usex partition)
		-DCHOLMOD_SUPERNODAL=$(usex supernodal)
		-DSUITESPARSE_DEMOS=$(usex test)
		-DSUITESPARSE_INCLUDEDIR_POSTFIX=""
	)

	if has_version 'virtual/blas[index64]'; then
		mycmakeargs+=( -DSUITESPARSE_USE_64BIT_BLAS=ON )
	fi

	if has_version 'virtual/blas[flexiblas]'; then
		mycmakeargs+=( -DBLA_VENDOR=FlexiBLAS )
	else
		mycmakeargs+=( -DBLA_VENDOR=Generic )
	fi
	# TODO: Figure out how to make sci-libs/mkl work. Bug 974246

	if use cuda; then
		cuda_add_sandbox
		addpredict "/dev/char/"

		mycmakeargs+=(
			-DSUITESPARSE_CUDA_ARCHITECTURES="${CUDAARCHS:-all-major}"
		)
		local -x CUDAHOSTCXX="$(cuda_gccdir)"
		local -x CUDAHOSTLD="$(tc-getCXX)"
	fi

	cmake_src_configure
}

src_test() {
	# Because we are not using cmake_src_test,
	# we have to manually go to BUILD_DIR
	cd "${BUILD_DIR}" || die
	# Run demo files
	local type=(
		di
		dl
		si
		sl
	)
	local prog=(
		demo
		simple
	)
	local matrix_file=(
		bcsstk01.tri
		lp_afiro.tri
		can___24.mtx
		c.tri
		bcsstk02.tri
	)
	local i
	local j
	local k
	for i in ${type[@]}; do
		for k in ${prog[@]}; do
			for j in ${matrix_file[@]}; do
				./cholmod_${i}_${k}   < "${S}/Demo/Matrix/${j}" \
					|| die "failed testing cholmod_${i}_${k} with ${j}"
			done
		done
	done
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
