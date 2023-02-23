# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature

DESCRIPTION="oneAPI Video Processing Library, dispatcher, tools, and examples"
HOMEPAGE="https://github.com/oneapi-src/oneVPL"
SRC_URI="https://github.com/oneapi-src/oneVPL/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="dri drm examples experimental +tools test vaapi wayland X"
RESTRICT="!test? ( test )"
# Most of these flags only have an effect on the tools
REQUIRED_USE="
	dri? ( X drm )
	drm? ( tools )
	X? ( tools vaapi )
	wayland? ( tools drm )
	vaapi? ( tools )
"

BDEPEND="virtual/pkgconfig"
DEPEND="
	x11-libs/libpciaccess
	vaapi? ( media-libs/libva[X?,wayland?,drm(+)?] )
	drm? ( x11-libs/libdrm )
	wayland? (
		dev-libs/wayland
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
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_DISPATCHER=ON
		# Headers, cmake and pkgconfig files
		-DBUILD_DEV=ON
		-DBUILD_EXAMPLES="$(usex examples)"
		-DINSTALL_EXAMPLE_CODE="$(usex examples)"
		-DBUILD_PREVIEW="$(usex experimental)"
		-DBUILD_DISPATCHER_ONEVPL_EXPERIMENTAL="$(usex experimental)"
		# Fails to build with experimental tools off if tools on
		-DBUILD_TOOLS_ONEVPL_EXPERIMENTAL="$(usex tools)"
		-DBUILD_TESTS="$(usex test)"
		-DBUILD_TOOLS="$(usex tools)"
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

src_install() {
	cmake_src_install
	# Remove these license files
	rm -r "${ED}/usr/share/vpl/licensing" || die
}

pkg_postinst() {
	optfeature_header "This package provides only the dispatcher, to use it install one or more implementations"
	optfeature "CPUs" media-libs/oneVPL-cpu
	optfeature "Intel GPUs newer then, and including, Intel Xe" media-libs/oneVPL-intel-gpu
	optfeature "Intel GPUs older then Intel Xe" media-libs/intel-mediasdk
}
