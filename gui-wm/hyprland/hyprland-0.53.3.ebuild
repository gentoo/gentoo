# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="A dynamic tiling Wayland compositor that doesn't sacrifice on its looks"
HOMEPAGE="https://github.com/hyprwm/Hyprland"

if [[ "${PV}" = *9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
else
	SRC_URI="https://github.com/hyprwm/${PN^}/releases/download/v${PV}/source-v${PV}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-source"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE="X +guiutils systemd"

# hyprpm (hyprland plugin manager) requires the dependencies at runtime
# so that it can clone, compile and install plugins.
HYPRPM_RDEPEND="
	app-alternatives/ninja
	>=dev-build/cmake-3.30
	dev-vcs/git
	virtual/pkgconfig
"
RDEPEND="
	${HYPRPM_RDEPEND}
	dev-cpp/tomlplusplus
	dev-libs/glib:2
	>=dev-libs/hyprlang-0.6.7
	dev-libs/libinput:=
	>=dev-libs/hyprgraphics-0.1.6:=
	dev-libs/re2:=
	>=dev-libs/udis86-1.7.2
	>=dev-libs/wayland-1.22.90
	>=gui-libs/aquamarine-0.10.0:=
	>=gui-libs/hyprcursor-0.1.9
	>=gui-libs/hyprutils-0.11.0:=
	media-libs/libglvnd
	media-libs/mesa
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	x11-libs/libXcursor
	X? (
		x11-libs/libxcb:0=
		x11-base/xwayland
		x11-libs/xcb-util-errors
		x11-libs/xcb-util-wm
	)
	guiutils? ( gui-libs/hyprland-guiutils )
	gui-apps/hyprwire
"

DEPEND="
	${RDEPEND}
	>=dev-libs/hyprland-protocols-0.6.4
	>=dev-libs/wayland-protocols-1.45
"
BDEPEND="
	|| ( >=sys-devel/gcc-15:* >=llvm-core/clang-19:* )
	app-misc/jq
	dev-build/cmake
	>=dev-util/hyprwayland-scanner-0.4.5
	virtual/pkgconfig
	dev-cpp/muParser
	dev-cpp/glaze
"
