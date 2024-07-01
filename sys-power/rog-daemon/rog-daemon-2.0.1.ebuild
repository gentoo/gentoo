# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Lightweight and modular ASUS ROG control daemon"
HOMEPAGE="https://github.com/mechakotik/${PN}"
SRC_URI="https://github.com/mechakotik/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd +profile +fan-curve +mux +panel-od"

# C++20 support is required
BDEPEND="
	|| ( >=sys-devel/gcc-8 >=sys-devel/clang-17 )
	dev-build/meson
"

src_configure() {
	local emesonargs=(
		$(usex "systemd" "-Dinit=systemd" "-Dinit=openrc")
		$(meson_use profile)
		$(meson_use fan-curve fan_curve)
		$(meson_use mux)
		$(meson_use panel-od panel_od)
	)
	meson_src_configure
}
