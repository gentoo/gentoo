# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

COMMIT=4d29e48433270a2af06b8bc711ca1fe5109746cd
DESCRIPTION="Wayland protocol extensions for Hyprland"
HOMEPAGE="https://github.com/hyprwm/hyprland-protocols"
SRC_URI="https://github.com/hyprwm/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

KEYWORDS="amd64 ~riscv"
LICENSE="BSD"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"
