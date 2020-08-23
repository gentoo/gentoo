# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Wayfire Config Manager"
HOMEPAGE="https://github.com/WayfireWM/wcm"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WayfireWM/wcm.git"
else
	SRC_URI="https://github.com/WayfireWM/wcm/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="
	dev-libs/libevdev
	dev-libs/libxml2
	dev-cpp/gtkmm:3.0[wayland]
	>=gui-wm/wayfire-${PV}
"

RDEPEND="${DEPEND}"

BDEPEND="
	dev-libs/wayland-protocols
	virtual/pkgconfig
"
