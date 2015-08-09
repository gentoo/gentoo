# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit games

DESCRIPTION="A parodic fantasy module for Neverwinter Nights"
HOMEPAGE="http://pixelscapes.com/penultima"
SRC_URI="http://c.vnfiles.ign.com/nwvault.ign.com/fms/files/modules/1674/PR0_and_PR1_Penultima_ReRolled_Starter_Pack_v1.4.zip
	http://c.vnfiles.ign.com/nwvault.ign.com/fms/files/modules/1675/PR2_Below_the_R00t.v1.zip
	http://c.vnfiles.ign.com/nwvault.ign.com/fms/files/modules/1676/PR3_Homeland_Security.v1.4.zip
	http://c.vnfiles.ign.com/nwvault.ign.com/fms/files/modules/1677/PR4_Pastor_of_Muppets.v1.1.zip
	http://c.vnfiles.ign.com/nwvault.ign.com/fms/files/modules/1678/PR5_The_Saving_Throw.v1.1.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="games-rpg/nwn"

src_install() {
	insinto "${GAMES_PREFIX_OPT}"/nwn/modules
	doins *.mod || die "Installing modules failed"

	insinto "${GAMES_PREFIX_OPT}"/nwn/hak
	doins *.hak || die "Installing hak files failed"

	insinto "${GAMES_PREFIX_OPT}"/nwn/music
	doins *.bmu || die "Installing music failed"

	insinto "${GAMES_PREFIX_OPT}"/nwn/movies
	doins *.bik || die "Installing movies failed"

	insinto "${GAMES_PREFIX_OPT}"/nwn/penultima_rerolled
	doins *.html *.jpg || die "Installing documentation failed"

	prepgamesdirs
}
