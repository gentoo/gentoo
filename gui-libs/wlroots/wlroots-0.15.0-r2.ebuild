# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Pluggable, composable, unopinionated modules for building a Wayland compositor"
HOMEPAGE="https://gitlab.freedesktop.org/wlroots/wlroots"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/${PN}/${PN}.git"
	inherit git-r3
	SLOT="0/9999"
else
	SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
	SLOT="0/15"
fi

LICENSE="MIT"
IUSE="vulkan x11-backend X"

DEPEND="
	>=dev-libs/libinput-1.14.0:0=
	>=dev-libs/wayland-1.20.0
	>=dev-libs/wayland-protocols-1.24
	media-libs/mesa[egl(+),gles2,gbm(+)]
	sys-auth/seatd:=
	virtual/libudev
	vulkan? (
		dev-util/glslang:0=
		dev-util/vulkan-headers:0=
		media-libs/vulkan-loader:0=
	)
	>=x11-libs/libdrm-2.4.109:0=
	x11-libs/libxkbcommon
	x11-libs/pixman
	x11-backend? ( x11-libs/libxcb:0= )
	X? (
		x11-base/xwayland
		x11-libs/libxcb:0=
		x11-libs/xcb-util-image
		x11-libs/xcb-util-wm
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-libs/wayland-protocols-1.24
	>=dev-util/meson-0.60.0
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/0.15.0-59b9518f.patch" )

src_configure() {
	# xcb-util-errors is not on Gentoo Repository (and upstream seems inactive?)
	local emesonargs=(
		"-Dxcb-errors=disabled"
		"-Dexamples=false"
		-Drenderers=$(usex vulkan 'gles2,vulkan' gles2)
		-Dxwayland=$(usex X enabled disabled)
		-Dbackends=drm,libinput$(usex x11-backend ',x11' '')
	)

	meson_src_configure
}

pkg_postinst() {
	elog "You must be in the input group to allow your compositor"
	elog "to access input devices via libinput."
}
