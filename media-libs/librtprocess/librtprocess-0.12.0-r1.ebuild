# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="Algorithms for RAW processing from RawTherapee"
HOMEPAGE="https://github.com/CarVac/librtprocess/"
SRC_URI="https://github.com/CarVac/librtprocess/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openmp"

BDEPEND="
	openmp? (
		|| (
			sys-devel/gcc[openmp]
			sys-devel/clang-runtime[openmp]
		)
	)
"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DOPTION_OMP=$(usex openmp)
	)
	cmake_src_configure
}
