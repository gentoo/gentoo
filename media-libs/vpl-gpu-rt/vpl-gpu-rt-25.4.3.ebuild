# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTE: please bump with the other parts of intel's media stack, listed below
# https://github.com/intel/vpl-gpu-rt/releases

EAPI=8

inherit cmake

DESCRIPTION="Intel Video Processing Library GPU Runtime"
HOMEPAGE="https://github.com/intel/vpl-gpu-rt/"
SRC_URI="https://github.com/intel/${PN}/archive/refs/tags/intel-onevpl-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-intel-onevpl-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	media-libs/gmmlib
	media-libs/libva
	x11-libs/libdrm[video_cards_intel]
"
# At runtime we need a dispatcher, libvpl is preferred but mediasdk also works
RDEPEND="${DEPEND}
	>=media-libs/libva-intel-media-driver-${PV}
	|| (
		media-libs/libvpl
		media-libs/intel-mediasdk
	)
"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DBUILD_RUNTIME=ON
		# To build the kernels we need to package the cm-compiler, use pre-built instead
		-DBUILD_KERNELS=OFF
		-DBUILD_TESTS="$(usex test)"
		# This only seems to do something if we BUILD_KERNELS=ON
		#-DBUILD_TOOLS="$(usex tools)"
		# OpenCL only has an effect if we build kernels
		-DENABLE_OPENCL=OFF
	)
	cmake_src_configure
}
