# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

Sparse_PV="7.12.2"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Simple but educational LDL^T matrix factorization algorithm"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

S="${WORKDIR}/${Sparse_P}/${PN^^}"
LICENSE="LGPL-2.1+"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}
	>=sci-libs/amd-3.3.4"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

src_configure() {
	# May slightly skew FP numbers if enabled, and we want to match
	# the expected output bit-by-bit in tests.
	use test && append-flags -ffp-contract=off

	# Define SUITESPARSE_INCLUDEDIR_POSTFIX to "" otherwise it take
	# the value suitesparse, and the include directory would be set to
	# /usr/include/suitesparse
	# This need to be set in all suitesparse ebuilds.
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=OFF
		-DSUITESPARSE_DEMOS=$(usex test)
		-DSUITESPARSE_INCLUDEDIR_POSTFIX=""
	)
	cmake_src_configure
}

src_test() {
	# Because we are not using cmake_src_test,
	# we have to manually go to BUILD_DIR
	cd "${BUILD_DIR}" || die
	# Some programs assume that they can access the Matrix folder in ${S}
	ln -s "${S}/Matrix" || die
	# Run demo files
	local demofiles=(
		ldllsimple
		ldlmain
		ldllmain
		ldlamd
		ldllamd
	)
	# not running ldlsimple until it does not "test" suitesparse version as well.
	local i
	for i in ${demofiles[@]}; do
		einfo "testing ${i}"
		./"${i}" > "${i}.out" || die "${i} failed to run"
		diff "${S}/Demo/${i}.out" "${i}.out" || die "failed testing ${i}"
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
