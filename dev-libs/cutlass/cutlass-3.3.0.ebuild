# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cuda cmake

DESCRIPTION="CUDA Templates for Linear Algebra Subroutines"
HOMEPAGE="https://github.com/NVIDIA/cutlass"
SRC_URI="https://github.com/NVIDIA/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-util/nvidia-cuda-toolkit"

src_prepare() {
	cmake_src_prepare
	cuda_src_prepare
}

src_configure() {
	mycmakeargs+=(
		-DCMAKE_CUDA_FLAGS="$(cuda_gccdir -f | tr -d \")"
		-DCUTLASS_ENABLE_HEADERS_ONLY=yes
		-DCUTLASS_ENABLE_TESTS=no
	)
	cuda_add_sandbox -w
	addpredict /dev/char
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rm -r "${ED}"/usr/test || die
}
