# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="extra plugins for wayfire"
HOMEPAGE="https://github.com/WayfireWM/wayfire-plugins-extra"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/wayfire-plugins-extra.git"
	SLOT="0/0.8"
else
	SRC_URI="https://github.com/WayfireWM/wayfire-plugins-extra/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64"
	SLOT="0/$(ver_cut 1-2)"
fi

LICENSE="MIT"

# no tests
RESTRICT="test"

WAYFIRE_REVDEP="
	dev-libs/glib:2
	dev-libs/libsigc++:2
	gui-libs/wf-config:=
	gui-libs/wlroots:=
	x11-libs/cairo
"

DEPEND="
	${WAYFIRE_REVDEP}
	dev-cpp/glibmm:2
	dev-cpp/nlohmann_json
	dev-libs/libevdev
	dev-libs/wayland
	>=gui-wm/wayfire-0.8.1
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-libs/wayland-protocols-1.12
	dev-util/wayland-scanner
	virtual/pkgconfig
"
