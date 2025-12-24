# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A 32-level game designed for competitive deathmatch play"
HOMEPAGE="https://freedoom.github.io"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	~games-fps/freedm-data-${PV}
	|| (
		games-engines/uzdoom
		games-engines/odamex
		games-fps/chocolate-doom
		games-fps/dsda-doom
	)
"

pkg_postinst() {
	elog "If you are looking for a single-player focused game, consider games-fps/freedoom."
}
