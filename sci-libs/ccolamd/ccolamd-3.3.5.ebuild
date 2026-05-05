# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

Sparse_PV="7.12.2"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Constrained Column approximate minimum degree ordering algorithm"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

S="${WORKDIR}/${Sparse_P}/${PN^^}"
LICENSE="BSD"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}"
RDEPEND="${DEPEND}"

src_configure() {
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
	# Run demo files
	./ccolamd_example > ccolamd_example.out || die "ccolamd_example failed to run"
	diff "${S}"/Demo/ccolamd_example.out ccolamd_example.out || die "failed testing ccolamd_example"
	./ccolamd_l_example > ccolamd_l_example.out || die die "ccolamd_l_example failed to run"
	diff "${S}"/Demo/ccolamd_l_example.out ccolamd_l_example.out || die "failed testing ccolamd_l_example"

	einfo "All tests passed"
}
