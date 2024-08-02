# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Aquamarine is a very light linux rendering backend library"
HOMEPAGE="https://github.com/hyprwm/aquamarine"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
else
	SRC_URI="https://github.com/hyprwm/${PN^}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-libs/wayland
	media-libs/mesa[opengl]
	media-libs/libdisplay-info
	>=dev-libs/libinput-1.26.1
	>=dev-util/hyprwayland-scanner-0.4.0
	>=gui-libs/hyprutils-0.1.5
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/libdrm
	x11-libs/pango
	x11-libs/pixman
	virtual/libudev
	sys-apps/hwdata
	>=sys-auth/seatd-0.8.0
"
DEPEND="
	${RDEPEND}
	dev-libs/wayland-protocols
"

BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_prepare() {
	sed -i "/add_compile_options(-O3)/d" "${S}/CMakeLists.txt" || die
	cmake_src_prepare
}
