# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="extra plugins for wayfire"
HOMEPAGE="https://github.com/WayfireWM/wayfire-plugins-extra"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/wayfire-plugins-extra.git"
else
	SRC_URI="https://github.com/WayfireWM/wayfire-plugins-extra/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="
	dev-cpp/glibmm:2
	x11-libs/pixman
	gnome-base/librsvg
	>=gui-libs/wlroots-0.16.0:0/16
	<gui-libs/wlroots-0.17.0:=
	>=gui-wm/wayfire-0.7.5
	x11-libs/cairo
	x11-libs/pixman
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
	virtual/pkgconfig
"
