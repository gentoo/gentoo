# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic toolchain-funcs

DESCRIPTION="Numerical linear algebra software package"
HOMEPAGE="https://ginkgo-project.github.io/"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/ginkgo-project/ginkgo"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-with-attribution"
SLOT="0"
IUSE="cuda hwloc +openmp"

RDEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit )
	hwloc? ( sys-apps/hwloc:= )
"
DEPEND="${RDEPEND}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/862705
	# https://github.com/ginkgo-project/ginkgo/issues/1657
	#
	# Do not trust it with LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	local mycmakeargs=(
		-DGINKGO_DEVEL_TOOLS=OFF
		-DGINKGO_BUILD_TESTS=OFF
		-DGINKGO_BUILD_BENCHMARKS=OFF
		-DGINKGO_BUILD_REFERENCE=ON
		-DGINKGO_BUILD_CUDA=$(usex cuda)
		-DGINKGO_BUILD_HWLOC=$(usex hwloc)
		-DGINKGO_BUILD_OMP=$(usex openmp)
	)
	cmake_src_configure
}
