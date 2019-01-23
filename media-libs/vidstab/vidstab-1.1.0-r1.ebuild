# Copyright 2018-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}

inherit cmake-multilib toolchain-funcs

DESCRIPTION="Video stabilization library"
HOMEPAGE="http://public.hronopik.de/vid.stab/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/georgmartius/vid.stab.git"
	inherit git-r3
else
	SRC_URI="https://github.com/georgmartius/vid.stab/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
	S="${WORKDIR}/vid.stab-${PV}"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="openmp cpu_flags_x86_sse2"
PATCHES=(
	"${FILESDIR}/vidstab-1.1.0-tests-should-exit-with-code-0-on-success.patch"
	"${FILESDIR}/vidstab-1.1.0-tests-use-sse2-only-if-available.patch"
)
src_prepare() {
	# USE=cpu_flags_x86_sse2 instead
	sed -E 's#include (FindSSE)##' -i CMakeLists.txt || die
	sed -E 's#include (FindSSE)##' -i tests/CMakeLists.txt || die
	# strip some CFLAGS
	for FILE_TO_PATCH in {,transcode/,tests/}CMakeLists.txt; do
		sed -E 's#(add_definitions.* )-g #\1#' -i ${FILE_TO_PATCH} || die
		sed -E 's#(add_definitions.* )-O3 #\1#' -i ${FILE_TO_PATCH} || die
	done
	cmake-utils_src_prepare
}

src_configure() {
	use openmp && tc-check-openmp
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
	local CMAKE_USE_DIR="${CMAKE_USE_DIR}/tests"
	local BUILD_DIR="${BUILD_DIR}/tests"
	cmake-utils_src_configure
	cmake-utils_src_make
	"${BUILD_DIR}"/tests || die
}
