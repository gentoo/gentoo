# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit vcs-snapshot

DESCRIPTION="The main game for the Minetest game engine"
HOMEPAGE="https://github.com/minetest/minetest_game"
SRC_URI="https://github.com/minetest/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=games-action/minetest-${PV}"

src_install() {
	insinto /usr/share/minetest/games/${PN}
	doins -r mods menu
	doins game.conf minetest.conf

	dodoc README.txt game_api.txt
}
