# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Wayland protocol extensions for Hyprland"
HOMEPAGE="https://github.com/hyprwm/hyprland-protocols"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/hyprwm/${PN}.git"
	inherit git-r3
else
	COMMIT=4d29e48433270a2af06b8bc711ca1fe5109746cd
	SRC_URI="https://github.com/hyprwm/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~riscv"
fi

LICENSE="BSD"
SLOT="0"

BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"
