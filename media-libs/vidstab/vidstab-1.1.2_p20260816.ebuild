# Copyright 2018-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib toolchain-funcs flag-o-matic

DESCRIPTION="Video stabilization library"
HOMEPAGE="http://public.hronopik.de/vid.stab/"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/georgmartius/vid.stab.git"
	inherit git-r3
else
	COMMIT="e2445c4081658318223762a696eb1c645c2d7168"
	SRC_URI="https://github.com/georgmartius/vid.stab/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/vid.stab-${COMMIT}"
fi
LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="openmp cpu_flags_x86_sse2"

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
