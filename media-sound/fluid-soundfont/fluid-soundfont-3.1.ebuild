# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="The Fluid R3 soundfont"
HOMEPAGE="http://musescore.org/en/handbook/soundfont"
SRC_URI="http://prereleases.musescore.org/soundfont/${PN}_${PV}.tar.gz
	 timidity? ( https://dev.gentoo.org/~hwoarang/distfiles/timidity.cfg.bz2 )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="timidity"

RDEPEND="timidity? ( app-eselect/eselect-timidity )"

src_install() {
	insinto /usr/share/sounds/sf2
	doins FluidR3_GM.sf2 FluidR3_GS.sf2

	dodoc README

	if use timidity; then
		insinto /usr/share/timidity/${PN}
		doins "${WORKDIR}"/timidity.cfg
	fi
}
