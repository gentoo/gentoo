# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils cdrom games

DESCRIPTION="Doom III: Resurrection of Evil expansion pack"
HOMEPAGE="http://www.doom3.com/"
SRC_URI=""

LICENSE="DOOM3"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="strip"

RDEPEND=">=games-fps/doom3-1.3.1302-r2"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/doom3
Ddir=${D}/${dir}

src_unpack() {
	cdrom_get_cds Setup/Data/d3xp/pak000.pk4
	# Change from showing "d3xp" in the "mods" menu within Doom 3
	# The ^1 changes the text to red
	echo '^1Resurrection of Evil' > description.txt
}

src_install() {
	insinto "${dir}"/d3xp

	einfo "Copying file from the disk..."
	doins "${CDROM_ROOT}"/Setup/Data/d3xp/pak000.pk4 \
		|| die "copying pak000"

	doins description.txt

	find "${Ddir}" -exec touch '{}' \;

	games_make_wrapper ${PN} "doom3 +set fs_game d3xp"
	make_desktop_entry ${PN} "Doom III - Resurrection of Evil" doom3

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "This is just the data portion of the game.  You will need to emerge"
	elog "games-fps/doom3 to play the game."
	echo
}
