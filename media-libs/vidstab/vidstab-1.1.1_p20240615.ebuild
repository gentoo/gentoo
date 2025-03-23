# Copyright 2018-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib toolchain-funcs flag-o-matic

DESCRIPTION="Video stabilization library"
HOMEPAGE="http://public.hronopik.de/vid.stab/"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/georgmartius/vid.stab.git"
	inherit git-r3
else
	COMMIT="8dff7ad3c10ac663745f2263037f6e42b993519c"
	SRC_URI="https://github.com/georgmartius/vid.stab/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/vid.stab-${COMMIT}"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="openmp cpu_flags_x86_sse2"

PATCHES=( "${FILESDIR}/${P}-cmake4.patch" )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DUSE_OMP="$(usex openmp)"
		-DSSE2_FOUND="$(usex cpu_flags_x86_sse2)"
	)
	cmake-multilib_src_configure
}

multilib_src_test() {
	local mycmakeargs=(
		-DUSE_OMP="$(usex openmp)"
		-DSSE2_FOUND="$(usex cpu_flags_x86_sse2)"
	)
	append-cflags $(test-flags-CC -fopenmp)
	local CMAKE_USE_DIR="${CMAKE_USE_DIR}/tests"
	local BUILD_DIR="${BUILD_DIR}/tests"
	cmake_src_configure
	cmake_build
	"${BUILD_DIR}"/tests || die
}
