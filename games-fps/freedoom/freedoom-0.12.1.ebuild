# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A complete free-content single-player focused game based on the Doom engine"
HOMEPAGE="https://freedoom.github.io"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	~games-fps/freedoom-data-${PV}
	|| (
		games-fps/gzdoom[nonfree(+)]
		games-engines/odamex
		games-fps/doomsday
		games-fps/prboom-plus
	)
"

pkg_postinst() {
	elog "If you are looking for a multiplayer-focused deathmatch game, consider games-fps/freedm."
}
