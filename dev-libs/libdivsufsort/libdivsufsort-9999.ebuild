# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGIT_REPO_URI="https://github.com/y-256/${PN}"
inherit cmake-utils multilib toolchain-funcs git-r3

DESCRIPTION="Suffix-sorting library (for BWT)"
HOMEPAGE="https://github.com/y-256/libdivsufsort"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="openmp"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cmake-utils_src_prepare

	# will appreciate saner approach, if there is any
	sed -i -e "s:\(DESTINATION \)lib:\1$(get_libdir):" \
		*/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=("-DBUILD_DIVSUFSORT64=ON" "-DUSE_OPENMP=$(usex openmp)")
	cmake-utils_src_configure
}
