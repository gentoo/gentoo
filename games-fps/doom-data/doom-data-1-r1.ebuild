# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
inherit eutils games

DESCRIPTION="collection of doom wad files from id"
HOMEPAGE="http://www.idsoftware.com/"
SRC_URI="mirror://gentoo/doom1.wad.bz2"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 arm sparc x86"
IUSE="doomsday"

DEPEND="doomsday? ( games-fps/doomsday )
	!<=games-fps/freedoom-0.4.1"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_install() {
	insinto "${GAMES_DATADIR}"/doom-data
	doins *.wad
	if use doomsday; then
		# Make wrapper for doomsday
		games_make_wrapper doomsday-demo "jdoom -file \
			${GAMES_DATADIR}/doom-data/doom1.wad"
		make_desktop_entry doomsday-demo "Doomsday - Demo"
	fi
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	if use doomsday; then
		elog "To use the doomsday engine, run doomsday-demo"
	else
		elog "A Doom engine is required to play the wad"
		elog "Enable the doomsday use flag if you want to use"
		elog "	the doomsday engine"
	fi
}
