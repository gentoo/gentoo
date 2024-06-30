# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Pluggable, composable, unopinionated modules for building a Wayland compositor"
HOMEPAGE="https://gitlab.freedesktop.org/wlroots/wlroots"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/${PN}/${PN}.git"
	inherit git-r3
	SLOT="0.18"
else
	SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/releases/${PV}/downloads/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
	SLOT="$(ver_cut 1-2)"
fi

LICENSE="MIT"
IUSE="liftoff +libinput +drm +session lcms vulkan x11-backend xcb-errors X"
REQUIRED_USE="
	drm? ( session )
	libinput? ( session )
	liftoff? ( drm )
	xcb-errors? ( || ( x11-backend X ) )
"

DEPEND="
	>=dev-libs/wayland-1.22.0
	media-libs/libglvnd
	|| (
		>=media-libs/mesa-24.1.0_rc1[opengl]
		<media-libs/mesa-24.1.0_rc1[egl(+),gles2]
	)
	>=x11-libs/libdrm-2.4.120
	x11-libs/libxkbcommon
	>=x11-libs/pixman-0.42.0
	drm? (
		media-libs/libdisplay-info:=
		sys-apps/hwdata
		liftoff? ( >=dev-libs/libliftoff-0.4 )
	)
	lcms? ( media-libs/lcms:2 )
	libinput? ( >=dev-libs/libinput-1.14.0:= )
	session? (
		sys-auth/seatd:=
		virtual/libudev
	)
	vulkan? (
		dev-util/glslang:=
		dev-util/vulkan-headers
		media-libs/vulkan-loader
	)
	xcb-errors? ( x11-libs/xcb-util-errors )
	x11-backend? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-renderutil
	)
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-wm
		x11-base/xwayland
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-libs/wayland-protocols-1.33
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_configure() {
	local backends=(
		$(usev drm)
		$(usev libinput)
		$(usev x11-backend 'x11')
	)
	local meson_backends=$(IFS=','; echo "${backends[*]}")
	local emesonargs=(
		$(meson_feature xcb-errors)
		-Dexamples=false
		-Drenderers=$(usex vulkan 'gles2,vulkan' gles2)
		$(meson_feature X xwayland)
		-Dbackends=${meson_backends}
		$(meson_feature session)
		$(meson_feature lcms color-management)
		$(meson_feature liftoff libliftoff)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	dodoc docs/*
}

pkg_postinst() {
	elog "You must be in the input group to allow your compositor"
	elog "to access input devices via libinput."
}
