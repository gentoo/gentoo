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

IUSE="dri drm test vaapi wayland X"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	dri? ( X drm )
	X? ( vaapi )
	wayland? ( drm )
"

RDEPEND="
	x11-libs/libpciaccess
	vaapi? ( media-libs/libva[X?,wayland?,drm(+)?] )
	drm? ( x11-libs/libdrm )
	wayland? (
		dev-libs/wayland
	)
	X? (
		x11-libs/libX11
		x11-libs/libxcb
	)
	!<media-libs/libvpl-2.11.0[tools]
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
		-DTOOLS_ENABLE_X11="$(usex X)"
		-DENABLE_WAYLAND="$(usex wayland)"
		-DENABLE_X11="$(usex X)"
		-DENABLE_DRI3="$(usex dri)"
		-DENABLE_VA="$(usex vaapi)"
		-DENABLE_DRM="$(usex drm)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
	)
	cmake_src_configure
}
