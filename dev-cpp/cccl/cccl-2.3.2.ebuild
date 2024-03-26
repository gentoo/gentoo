# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="CUDA C++ Core Libraries"
HOMEPAGE="https://github.com/NVIDIA/cccl"
SRC_URI="https://github.com/NVIDIA/cccl/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror"

DEPEND="!!dev-util/nvidia-cuda-toolkit"

src_configure() {
	local mycmakeargs=(
		-DCCCL_ENABLE_LIBCUDACXX=OFF
		-Dlibcudacxx_ENABLE_INSTALL_RULES=ON
		-DCCCL_ENABLE_CUB=OFF
		-DCUB_ENABLE_INSTALL_RULES=ON
		-DCCCL_ENABLE_THRUST=OFF
		-DTHRUST_ENABLE_INSTALL_RULES=ON
		-DCCCL_ENABLE_TESTING=OFF
	)
	cmake_src_configure
}
