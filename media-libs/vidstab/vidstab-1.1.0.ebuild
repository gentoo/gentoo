# Copyright 2018-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils toolchain-funcs

DESCRIPTION="Video stabilization library"
HOMEPAGE="http://public.hronopik.de/vid.stab/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/georgmartius/vid.stab.git"
	inherit git-r3
else
	SRC_URI="https://github.com/georgmartius/vid.stab/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/vid.stab-${PV}"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="openmp cpu_flags_x86_sse2"
PATCHES=(
	"${FILESDIR}/vidstab-1.1.0-tests-should-exit-with-code-0-on-success.patch"
)
src_prepare() {
	# USE=cpu_flags_x86_sse2 instead
	sed -E 's#include (FindSSE)##' -i CMakeLists.txt
	# strip some CFLAGS
	for FILE_TO_PATCH in {,transcode/,tests/}CMakeLists.txt; do
		sed -E 's#(add_definitions.* )-g #\1#' -i ${FILE_TO_PATCH}
		sed -E 's#(add_definitions.* )-O3 #\1#' -i ${FILE_TO_PATCH}
	done
	cmake-utils_src_prepare
}

src_configure() {
	use openmp && tc-check-openmp
	local mycmakeargs=(
		-DUSE_OMP="$(usex openmp)"
		-DSSE2_FOUND="$(usex cpu_flags_x86_sse2)"
	)
	cmake-utils_src_configure
}

src_test() {
	cd tests || die
	local mycmakeargs=(
		-DUSE_OMP="$(usex openmp)"
	)
	local CMAKE_USE_DIR="${CMAKE_USE_DIR}/tests"
	local BUILD_DIR="${BUILD_DIR}/tests"
	cmake-utils_src_configure
	cmake-utils_src_make
	"${BUILD_DIR}"/tests || die
}
