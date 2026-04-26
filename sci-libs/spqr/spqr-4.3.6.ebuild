# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

Sparse_PV="7.12.2"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Multithreaded multifrontal sparse QR factorization library"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

S="${WORKDIR}/${Sparse_P}/${PN^^}"
LICENSE="GPL-2+"
SLOT="0/4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="cuda doc test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}
	>=sci-libs/cholmod-5.3.4
	virtual/blas
    cuda? (
        dev-util/nvidia-cuda-toolkit
        x11-drivers/nvidia-drivers
    )"
RDEPEND="${DEPEND}"
BDEPEND="doc? (
	virtual/latex-base
	dev-texlive/texlive-plaingeneric
)"

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
	cmake_src_configure
}

src_test() {
	# Because we are not using cmake_src_test,
	# we have to manually go to BUILD_DIR
	cd "${BUILD_DIR}" || die
	# Run demo files
	./qrsimple  < "${S}"/Matrix/ash219.mtx || die "failed testing"
	./qrsimplec < "${S}"/Matrix/ash219.mtx || die "failed testing"
	./qrsimple  < "${S}"/Matrix/west0067.mtx || die "failed testing"
	./qrsimplec < "${S}"/Matrix/west0067.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/a2.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/r2.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/a04.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/a2.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/west0067.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/c2.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/a0.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/lfat5b.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/bfwa62.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/LFAT5.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/b1_ss.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/bcspwr01.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/lpi_galenet.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/lpi_itest6.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/ash219.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/a4.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/s32.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/c32.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/lp_share1b.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/a1.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/GD06_theory.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/GD01_b.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/Tina_AskCal_perm.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/Tina_AskCal.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/GD98_a.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/Ragusa16.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/young1c.mtx || die "failed testing"
	./qrdemo < "${S}"/Matrix/lp_e226_transposed.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/a2.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/r2.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/a04.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/a2.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/west0067.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/c2.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/a0.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/lfat5b.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/bfwa62.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/LFAT5.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/b1_ss.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/bcspwr01.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/lpi_galenet.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/lpi_itest6.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/ash219.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/a4.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/s32.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/c32.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/lp_share1b.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/a1.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/GD06_theory.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/GD01_b.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/Tina_AskCal_perm.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/Tina_AskCal.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/GD98_a.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/Ragusa16.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/young1c.mtx || die "failed testing"
	./qrdemoc < "${S}"/Matrix/lp_e226_transposed.mtx || die "failed testing"
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
