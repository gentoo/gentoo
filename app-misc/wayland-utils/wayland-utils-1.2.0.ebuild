# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Display information about supported Wayland protocols and current compositor"
HOMEPAGE="https://gitlab.freedesktop.org/wayland/wayland-utils"
SRC_URI="https://gitlab.freedesktop.org/wayland/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-libs/wayland-1.20.0
	>=x11-libs/libdrm-2.4.109
"
DEPEND="${RDEPEND}
	dev-libs/wayland-protocols
"
BDEPEND="dev-util/wayland-scanner"

src_configure() {
	local emesonargs=(
		-Ddrm=enabled
	)
	meson_src_configure
}
