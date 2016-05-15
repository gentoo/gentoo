# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MOD_DESC="Single player maps"
MOD_NAME="Make it to Morning"

inherit eutils games games-mods

HOMEPAGE="http://www.jimwilkie.co.uk/mitm/"
SRC_URI="MakeItToMorning1-6.zip"

LICENSE="all-rights-reserved"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="fetch"

RDEPEND="games-fps/doom3-roe
	games-fps/doom3[opengl,roe]"

pkg_nofetch() {
	elog "Go to http://www.gamewatcher.com/mods/doom-3-resurrection-of-evil-mod/make-it-to-morning-1-6"
	elog "and download ${A} and place the file in ${DISTDIR}"
}

src_unpack() {
	mkdir mitm || die
	cd mitm || die
	unpack ${A}
}

src_install() {
	games_make_wrapper ${PN} \
		"doom3 +set fs_game_base d3xp +set fs_game mitm +map mitm"
	make_desktop_entry ${PN} "Doom 3 - ${MOD_NAME} (1)" doom3
	local i
	for i in {2..6} ; do
		games_make_wrapper ${PN}${i} \
			"doom3 +set fs_game_base d3xp +set fs_game mitm +map mitm${i}"
		make_desktop_entry ${PN}${i} "Doom 3 - ${MOD_NAME} (${i})" doom3
	done
	games-mods_src_install
}
