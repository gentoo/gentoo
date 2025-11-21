# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit meson

MY_P="RazerGenie-${PV}"
DESCRIPTION="Razer devices configurator"
HOMEPAGE="https://github.com/z3ntu/RazerGenie"
SRC_URI="https://github.com/z3ntu/RazerGenie/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/libopenrazer
	dev-qt/qtbase:6[dbus,gui,network,widgets]
"

RDEPEND="${DEPEND}
	sys-apps/openrazer
	x11-themes/hicolor-icon-theme
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	meson_src_configure
}
