# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Wayfire Config Manager"
HOMEPAGE="https://github.com/WayfireWM/wcm"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/wcm.git"
	SLOT="0/0.10"
else
	SRC_URI="https://github.com/WayfireWM/wcm/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64"
	SLOT="0/$(ver_cut 1-2)"
fi

LICENSE="MIT"

RESTRICT="test" # no tests

COMMON_DEPEND="
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0[wayland]
	dev-libs/glib:2
	dev-libs/libevdev
	dev-libs/libsigc++:2
	dev-libs/libxml2:=
	dev-libs/wayland
	gui-apps/wf-shell:${SLOT}
	gui-libs/wf-config:${SLOT}
	gui-wm/wayfire:${SLOT}
	media-libs/libepoxy
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libxkbcommon
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="
	${COMMON_DEPEND}
	dev-libs/wayland-protocols
"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.0-incompatible-pointer-types.patch
)

src_prepare() {
	default

	sed 's/DestkopSettings/DesktopSettings/' -i wayfire-config-manager.desktop
}

src_configure() {
	local emesonargs=(
		-Dwf_shell=enabled
		-Denable_wdisplays=true
	)

	meson_src_configure
}
