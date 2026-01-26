# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A fast and consistent wire protocol for IPC"
HOMEPAGE="https://github.com/hyprwm/hyprwire"

SRC_URI="https://github.com/hyprwm/${PN^}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${PV}"
KEYWORDS="~amd64"

LICENSE="BSD"
SLOT="0"

DEPEND="
	dev-libs/libffi
	>=gui-libs/hyprutils-0.9.0
"
RDEPEND="${DEPEND}"
