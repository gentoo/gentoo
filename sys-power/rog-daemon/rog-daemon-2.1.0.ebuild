# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Lightweight and modular ASUS ROG control daemon"
HOMEPAGE="https://github.com/mechakotik/rog-daemon"
SRC_URI="https://github.com/mechakotik/rog-daemon/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd +profile +fan-curve +mux +panel-od"

BDEPEND="
	|| ( sys-devel/gcc sys-devel/clang )
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
