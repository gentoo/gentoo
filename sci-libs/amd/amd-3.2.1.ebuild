# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED="fortran"
inherit cmake fortran-2

Sparse_PV="7.3.1"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Library to order a sparse matrix prior to Cholesky factorization"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc fortran test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

S="${WORKDIR}/${Sparse_P}/${PN^^}"

src_configure() {
	local mycmakeargs=(
		-DNSTATIC=ON
		-DNFORTRAN=$(usex fortran OFF ON)
		-DDEMO=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	# Because we are not using cmake_src_test,
	# we have to manually go to BUILD_DIR
	cd "${BUILD_DIR}"
	# Run demo files
	local demofiles=(
		amd_demo
		amd_l_demo
		amd_demo2
		amd_simple
	)
	if use fortran; then
		demofiles+=(
			amd_f77simple
			amd_f77demo
		)
	fi
	for i in ${demofiles[@]}; do
		./"${i}" > "${i}.out" || die "failed to run test ${i}"
		diff "${S}/Demo/${i}.out" "${i}.out" || die "failed testing ${i}"
	done
	einfo "All tests passed"
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
