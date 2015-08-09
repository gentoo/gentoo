# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit games

DESCRIPTION="The bundled Shadowlords, Dreamcatcher, and Demon campaigns by Hall-of-Famer Adam Miller"
HOMEPAGE="http://www.adamandjamie.com/mod/nwn_campaign.aspx"
SRC_URI="http://vnfiles.ign.com/nwvault.ign.com/fms/files/modules/4273/ShadowlordsDreamcatcherDemon.exe"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="mirror bindist"

DEPEND="app-arch/p7zip"
RDEPEND="games-rpg/nwn"

src_unpack() {
	7z x "${DISTDIR}/ShadowlordsDreamcatcherDemon.exe" || die "Unpacking failed"
}

src_install() {
	insinto "${GAMES_PREFIX_OPT}"/nwn/modules
	doins *.mod || die "Installing modules failed"

	insinto "${GAMES_PREFIX_OPT}"/nwn/hak
	doins *.hak || die "Installing hak files failed"

	insinto "${GAMES_PREFIX_OPT}"/nwn/music
	doins *.bmu || die "Installing music failed"

	insinto "${GAMES_PREFIX_OPT}"/nwn/movies
	doins *.bik || die "Installing movies failed"

	insinto "${GAMES_PREFIX_OPT}"/nwn/shadowlords_dreamcatcher_demon
	doins *.txt || die "Installing documentation failed"

	prepgamesdirs
}
