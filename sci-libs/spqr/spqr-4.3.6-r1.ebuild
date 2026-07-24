# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake cuda toolchain-funcs

Sparse_PV="7.12.2"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Multithreaded multifrontal sparse QR factorization library"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

S="${WORKDIR}/${Sparse_P}/${PN^^}"
LICENSE="GPL-2+"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="cuda doc test"
RESTRICT="!test? ( test )"

DEPEND="
	>=sci-libs/suitesparseconfig-${Sparse_PV}:=
	>=sci-libs/cholmod-5.3.4:=
	virtual/blas
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
		x11-drivers/nvidia-drivers
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? (
		virtual/latex-base
		dev-texlive/texlive-plaingeneric
	)
"

src_prepare() {
	cmake_src_prepare

	if use cuda; then
		cuda_src_prepare
	fi
}

src_configure() {
	# Define SUITESPARSE_INCLUDEDIR_POSTFIX to "" otherwise it take
	# the value suitesparse, and the include directory would be set to
	# /usr/include/suitesparse
	# This need to be set in all suitesparse ebuilds.
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=OFF
		-DSPQR_USE_CUDA=$(usex cuda)
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

	local simple=(
		ash219
		west0067
	)
	local demo=(
		a04
		a0
		a1
		a2
		a4
		ash219
		b1_ss
		bcspwr01
		bfwa62
		c2
		c32
		GD01_b
		GD06_theory
		GD98_a
		lfat5b
		LFAT5
		lp_e226_transposed
		lpi_galenet
		lpi_itest6
		lp_share1b
		r2
		Ragusa16
		s32
		Tina_AskCal
		Tina_AskCal_perm
		west0067
		young1c
	)

	local simples=(
		qrsimple
		qrsimplec
		qrsimplec_int32
	)
	local demos=(
		qrdemo
		qrdemo_int32
		qrdemoc
		qrdemoc_int32
	)
	declare -A testsuite
	local i
	local j
	for i in "${simples[@]}"; do
		testsuite["${i}"]=${simple[@]}
	done
	for i in "${demos[@]}"; do
		testsuite["${i}"]=${demo[@]}
	done
	# Run demo files
	for i in ${!testsuite[@]}; do
		for j in ${testsuite[${i[@]}]}; do
			./${i} < "${S}"/Matrix/${j}.mtx || die "failed testing ${i} with ${j}"
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
