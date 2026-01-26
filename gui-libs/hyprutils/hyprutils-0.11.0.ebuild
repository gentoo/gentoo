# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Hyprland utilities library used across the ecosystem"
HOMEPAGE="https://github.com/hyprwm/hyprutils"

SRC_URI="https://github.com/hyprwm/${PN^}/archive/refs/tags/v${PV}/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
KEYWORDS="~amd64"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"

DEPEND="
	x11-libs/pixman
"
RDEPEND="${DEPEND}"
