# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A complete free-content single-player focused game based on the Doom engine"
HOMEPAGE="https://freedoom.github.io"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="
	~games-fps/freedoom-data-${PV}
	|| (
		games-engines/uzdoom
		games-engines/odamex
		games-fps/chocolate-doom
		games-fps/dsda-doom
	)
"

pkg_postinst() {
	elog "If you are looking for a multiplayer-focused deathmatch game, consider games-fps/freedm."
}
