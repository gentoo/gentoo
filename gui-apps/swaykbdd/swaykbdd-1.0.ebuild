# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Per-window keyboard layout switcher for Sway"
HOMEPAGE="https://github.com/artemsen/swaykbdd"
SRC_URI="https://github.com/artemsen/swaykbdd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/json-c:0="
RDEPEND="
	gui-wm/sway
	${DEPEND}
"
