# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="extra plugins for wayfire"
HOMEPAGE="https://github.com/WayfireWM/wayfire-plugins-extra"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/wayfire-plugins-extra.git"
else
	SRC_URI="https://github.com/WayfireWM/wayfire-plugins-extra/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="
	dev-cpp/glibmm
	>=gui-libs/wlroots-0.11.0
	>=gui-wm/wayfire-${PV%.*}
	x11-libs/cairo
"
RDEPEND="${DEPEND}"

BDEPEND="
	dev-libs/wayland-protocols
	virtual/pkgconfig
"
