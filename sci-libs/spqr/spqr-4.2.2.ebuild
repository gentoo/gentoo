# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

Sparse_PV="7.3.1"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Multithreaded multifrontal sparse QR factorization library"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc openmp test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}
	>=sci-libs/amd-3.2.1
	>=sci-libs/colamd-3.2.1
	>=sci-libs/cholmod-5.0.1
	virtual/blas"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

S="${WORKDIR}/${Sparse_P}/${PN^^}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DNSTATIC=ON
		-DNOPENMP=$(usex openmp OFF ON)
		-DDEMO=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	# Because we are not using cmake_src_test,
	# we have to manually go to BUILD_DIR
	cd "${BUILD_DIR}"
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
		pushd "${S}/Doc"
		emake clean
		rm -rf *.pdf
		emake
		popd
		DOCS="${S}/Doc/*.pdf"
	fi
	cmake_src_install
}
