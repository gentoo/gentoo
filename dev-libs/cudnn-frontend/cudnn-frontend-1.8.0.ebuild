# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="A c++ wrapper for the cudnn backend API"
HOMEPAGE="https://github.com/NVIDIA/cudnn-frontend"
SRC_URI="https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/8"
KEYWORDS="~amd64"

RDEPEND="=dev-libs/cudnn-8*
	dev-util/nvidia-cuda-toolkit"
DEPEND="${RDEPEND}"

IUSE="test"

RESTRICT="test" # Fail in sandbox

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_configure() {
	local mycmakeargs=(
		-DCUDNN_FRONTEND_BUILD_TESTS=$(usex test)
		-DCUDNN_FRONTEND_BUILD_SAMPLES=OFF
	)
	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/bin/tests || die
}
