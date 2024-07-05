# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Intel Video Processing Library tools"
HOMEPAGE="https://github.com/intel/libvpl-tools/"
SRC_URI="https://github.com/intel/libvpl-tools/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="dri +drm opencl test +vaapi wayland X"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	dri? ( X )
	opencl? ( X )
	vaapi? ( drm )
	wayland? ( vaapi )
	X? ( vaapi )
"

RDEPEND="
	drm? ( x11-libs/libdrm[video_cards_intel] )
	opencl? ( virtual/opencl )
	vaapi? ( media-libs/libva[X?,wayland?,drm(+)?] )
	wayland? (
		dev-libs/wayland
	)
	X? (
		x11-libs/libX11
		x11-libs/libxcb
	)
	x11-libs/libpciaccess
	>=media-libs/libvpl-2.11.0:=
"

DEPEND="${RDEPEND}
	wayland? (
		dev-libs/wayland-protocols
	)
"

BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTS="$(usex test)"

		-DBUILD_EXPERIMENTAL="$(usex X)"
		-DTOOLS_ENABLE_X11="$(usex X)"
		-DTOOLS_ENABLE_SCREEN_CAPTURE="$(usex X)"
		-DTOOLS_ENABLE_RENDER="$(usex X)"
		-DTOOLS_ENABLE_OPENCL="$(usex opencl)"

		-DENABLE_DRI3="$(usex dri)"
		-DENABLE_DRM="$(usex drm)"
		-DENABLE_VA="$(usex vaapi)"
		-DENABLE_WAYLAND="$(usex wayland)"
		-DENABLE_X11="$(usex X)"

		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
	)
	cmake_src_configure
}
