# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps meson

DESCRIPTION="Pluggable, composable, unopinionated modules for building a Wayland compositor"
HOMEPAGE="https://github.com/swaywm/wlroots"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/swaywm/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/swaywm/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

LICENSE="MIT"
SLOT="0/9999"
IUSE="elogind icccm seatd systemd x11-backend X"
REQUIRED_USE="?? ( elogind systemd )"

DEPEND="
	>=dev-libs/libinput-1.9.0:0=
	>=dev-libs/wayland-1.19.0
	>=dev-libs/wayland-protocols-1.17.0
	media-libs/mesa[egl,gles2,gbm]
	virtual/libudev
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pixman
	elogind? ( >=sys-auth/elogind-237 )
	icccm? ( x11-libs/xcb-util-wm )
	seatd? ( sys-auth/seatd:= )
	systemd? ( >=sys-apps/systemd-237 )
	x11-backend? ( x11-libs/libxcb:0= )
	X? (
		x11-base/xorg-server[wayland]
		x11-libs/libxcb:0=
		x11-libs/xcb-util-image
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-libs/wayland-protocols-1.17
	>=dev-util/meson-0.56.0
	virtual/pkgconfig
"

src_configure() {
	# xcb-util-errors is not on Gentoo Repository (and upstream seems inactive?)
	local emesonargs=(
		"-Dxcb-errors=disabled"
		-Dxcb-icccm=$(usex icccm enabled disabled)
		-Dxwayland=$(usex X enabled disabled)
		-Dx11-backend=$(usex x11-backend enabled disabled)
		"-Dexamples=false"
		"-Dwerror=false"
		-Dlibseat=$(usex seatd enabled disabled)
	)
	if use systemd; then
		emesonargs+=("-Dlogind=enabled" "-Dlogind-provider=systemd")
	elif use elogind; then
		emesonargs+=("-Dlogind=enabled" "-Dlogind-provider=elogind")
	else
		emesonargs+=("-Dlogind=disabled")
	fi

	meson_src_configure
}

pkg_postinst() {
	elog "You must be in the input group to allow your compositor"
	elog "to access input devices via libinput."
}
