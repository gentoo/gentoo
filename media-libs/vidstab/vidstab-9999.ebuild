# Copyright 2018-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib toolchain-funcs flag-o-matic

DESCRIPTION="Video stabilization library"
HOMEPAGE="http://public.hronopik.de/vid.stab/"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/georgmartius/vid.stab.git"
	inherit git-r3
else
	SRC_URI="https://github.com/georgmartius/vid.stab/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~mips ~ppc ~ppc64 ~sparc ~x86"
	S="${WORKDIR}/vid.stab-${PV}"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="openmp cpu_flags_x86_sse2 test"

RESTRICT="!test? ( test )"
DEPEND="test? ( dev-lang/orc )"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	# USE=cpu_flags_x86_sse2 instead
	sed -E 's#include (FindSSE)##' -i CMakeLists.txt || die
	sed -E 's#include (FindSSE)##' -i tests/CMakeLists.txt || die
	# strip some CFLAGS
	for FILE_TO_PATCH in {,transcode/,tests/}CMakeLists.txt; do
		sed -E 's#(add_definitions.* )-g #\1#' -i ${FILE_TO_PATCH} || die
		sed -E 's#(add_definitions.* )-O3 #\1#' -i ${FILE_TO_PATCH} || die
	done
	cmake_src_prepare
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
