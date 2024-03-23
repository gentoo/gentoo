# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic optfeature

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

IUSE="dri test tools wayland X"
# Test not working at the moment
#RESTRICT="!test? ( test )"
RESTRICT="test"
REQUIRED_USE="
	dri? ( X )
"

# x11-libs/libdrm[video_cards_intel] for intel_bufmgr.h in samples
# bug #805224
RDEPEND="
	x11-libs/libpciaccess[${MULTILIB_USEDEP}]
	>=media-libs/libva-intel-media-driver-${PV}[${MULTILIB_USEDEP}]
	media-libs/libva[X?,wayland?,${MULTILIB_USEDEP}]
	x11-libs/libdrm[video_cards_intel,${MULTILIB_USEDEP}]
	wayland? (
		dev-libs/wayland[${MULTILIB_USEDEP}]
	)
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libxcb[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	wayland? (
		dev-libs/wayland-protocols
	)
"
BDEPEND="
	wayland? (
		dev-util/wayland-scanner
	)
"

PATCHES=(
	# https://github.com/Intel-Media-SDK/MediaSDK/pull/2998
	"${FILESDIR}/${PN}-23.2.0-gcc13.patch"
)

src_configure() {
	# ODR violation (bug #924366)
	filter-lto

	cmake-multilib_src_configure
}

multilib_src_configure() {
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
