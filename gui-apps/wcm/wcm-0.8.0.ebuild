# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Wayfire Config Manager"
HOMEPAGE="https://github.com/WayfireWM/wcm"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/wcm.git"
	SLOT="0/9999"
else
	SRC_URI="https://github.com/WayfireWM/wcm/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm64 ~x86"
	SLOT="0/$(ver_cut 1-2)"
fi

LICENSE="MIT"

RESTRIC="test" # no tests

CDEPEND="
	dev-libs/libevdev
	dev-libs/libxml2
	dev-libs/wayland
	dev-cpp/gtkmm:3.0[wayland]
	gui-apps/wf-shell:${SLOT}
	gui-libs/wf-config:${SLOT}
	gui-wm/wayfire:${SLOT}
	x11-libs/libxkbcommon
"
RDEPEND="${CDEPEND}"
DEPEND="
	${CDEPEND}
	dev-libs/wayland-protocols
"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dwf_shell=enabled
		-Denable_wdisplays=true
	)

	meson_src_configure
}
