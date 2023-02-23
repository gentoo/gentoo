# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature

if [[ ${PV} == *9999 ]] ; then
	: ${EGIT_REPO_URI:="https://github.com/Intel-Media-SDK/MediaSDK"}
	if [[ ${PV%9999} != "" ]] ; then
		: ${EGIT_BRANCH:="release/${PV%.9999}"}
	fi
	inherit git-r3
fi

DESCRIPTION="Intel Media SDK"
HOMEPAGE="https://github.com/Intel-Media-SDK/MediaSDK"
if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
else
	SRC_URI="https://github.com/Intel-Media-SDK/MediaSDK/archive/intel-mediasdk-${PV}.tar.gz"
	S="${WORKDIR}/MediaSDK-intel-mediasdk-${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

IUSE="dri test +tools wayland X"
# Test not working at the moment
#RESTRICT="!test? ( test )"
RESTRICT="test"
# Most of these flags only have an effect on the tools
REQUIRED_USE="
	dri? ( X )
	wayland? ( tools )
	X? ( tools )
"

# x11-libs/libdrm[video_cards_intel] for intel_bufmgr.h in samples
# bug #805224
DEPEND="
	x11-libs/libpciaccess
	>=media-libs/libva-intel-media-driver-${PV}
	media-libs/libva[X?,wayland?]
	x11-libs/libdrm[video_cards_intel]
	wayland? (
		dev-libs/wayland
		dev-util/wayland-scanner
		dev-libs/wayland-protocols
	)
	X? (
		x11-libs/libX11
		x11-libs/libxcb
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		# OpenCL only has an effect if we build kernels
		-DENABLE_OPENCL=OFF
		-DBUILD_TUTORIALS=OFF
		# Need to package the cm-compiler to build kernels, use pre-built instead
		-DBUILD_KERNELS=OFF
		-DBUILD_RUNTIME=ON
		-DBUILD_DISPATCHER=ON
		-DBUILD_TOOLS="$(usex tools)"
		# Cannot build tools without samples
		-DBUILD_SAMPLES="$(usex tools)"
		-DBUILD_TESTS="$(usex test)"
		-DENABLE_X11="$(usex X)"
		-DENABLE_X11_DRI3="$(usex dri)"
		-DENABLE_WAYLAND="$(usex wayland)"
	)

	cmake_src_configure
}

pkg_postinst() {
	optfeature "Intel GPUs newer then, and including, Intel Xe" media-libs/oneVPL-intel-gpu
}
