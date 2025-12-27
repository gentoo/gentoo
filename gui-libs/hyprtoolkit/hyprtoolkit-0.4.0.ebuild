# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A modern C++ Wayland-native GUI toolkit"
HOMEPAGE="https://github.com/hyprwm/hyprtoolkit"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
else
	SRC_URI="https://github.com/hyprwm/${PN^}/archive/refs/tags/v${PV}/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${PV}"

	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-cpp/gtest )
"
DEPEND="
	>=dev-libs/hyprgraphics-0.4.0
	dev-libs/wayland
	dev-libs/wayland-protocols
	>=gui-libs/aquamarine-0.10.0
	dev-libs/glib:2
	>=dev-libs/hyprlang-0.6.0
	>=gui-libs/hyprutils-0.10.4
	dev-libs/iniparser
	media-libs/libglvnd
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pixman
	x11-libs/pango
"
RDEPEND="${DEPEND}"

src_configure() {
    local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
    )
    cmake_src_configure
}
