# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="Highly optimized CLI and library to count primes"
HOMEPAGE="https://github.com/kimwalisch/primecount"
SRC_URI="https://github.com/kimwalisch/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/8"  # subslot is first component of libprimecount.so version
KEYWORDS="~amd64 ~riscv"
IUSE="+executable openmp test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-mathematics/primesieve-12.0:="
RDEPEND="${DEPEND}"

DOCS=(
	ChangeLog
	README.md
	doc/Credits.md
	doc/Easy-Special-Leaves.pdf
	doc/Hard-Special-Leaves.pdf
	doc/Records.md
	doc/References.md
	doc/alpha-factor-dr.pdf
	doc/alpha-factor-gourdon.pdf
	doc/alpha-factor-lmo.pdf
	doc/libprimecount.md
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_LIBPRIMESIEVE="OFF"
		-DBUILD_PRIMECOUNT="$(usex executable)"
		-DBUILD_STATIC_LIBS="OFF"
		-DBUILD_TESTS="$(usex test)"
		-DWITH_OPENMP="$(usex openmp)"
	)

	cmake_src_configure
}
