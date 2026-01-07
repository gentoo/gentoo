# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

Sparse_PV="7.0.0"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Constrained Column approximate minimum degree ordering algorithm"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-7.0.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${Sparse_P}/${PN^^}"

multilib_src_configure() {
	local mycmakeargs=(
		-DNSTATIC=ON
		-DDEMO=$(usex test)
	)
	cmake_src_configure
}

multilib_src_test() {
	# Run demo files
	./ccolamd_example > ccolamd_example.out || die "failed to run test ccolamd_example"
	diff "${S}"/Demo/ccolamd_example.out ccolamd_example.out || die "failed testing ccolamd_example"
	./ccolamd_l_example > ccolamd_l_example.out || die "failed to run test ccolamd_l_example"
	diff "${S}"/Demo/ccolamd_l_example.out ccolamd_l_example.out || die "failed testing ccolamd_l_example"
}
