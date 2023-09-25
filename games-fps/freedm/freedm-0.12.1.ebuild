# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A 32-level game designed for competitive deathmatch play"
HOMEPAGE="https://freedoom.github.io"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	~games-fps/freedm-data-${PV}
	|| (
		games-fps/gzdoom[nonfree(+)]
		games-engines/odamex
		games-fps/chocolate-doom
		games-fps/doomsday
		games-fps/prboom-plus
	)
"

pkg_postinst() {
	elog "If you are looking for a single-player focused game, consider games-fps/freedoom."
}
