# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Compiz like 3D wayland compositor"
HOMEPAGE="https://github.com/WayfireWM/wf-shell"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/${PN}.git"
	SLOT="0/9999"
else
	SRC_URI="https://github.com/WayfireWM/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
	SLOT="0/$(ver_cut 1-2)"
fi

LICENSE="MIT"
IUSE="+pulseaudio"

# no tests
RESTRICT="test"

DEPEND="
	dev-cpp/gtkmm:3.0[wayland]
	dev-libs/gobject-introspection
	dev-libs/libdbusmenu
	>=gui-libs/gtk-layer-shell-0.6
	dev-libs/wayland
	gui-libs/wf-config:${SLOT}
	gui-wm/wayfire:${SLOT}
	pulseaudio? ( media-libs/libpulse )
"
RDEPEND="${DEPEND}
	gui-apps/wayland-logout
"
BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_configure () {
	local emesonargs=(
		"$(meson_feature pulseaudio pulse)"
		-Dwayland-logout=false
	)
	meson_src_configure
}
