# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="FlightGear data files"
HOMEPAGE="http://www.flightgear.org/"
EGIT_REPO_URI="git://git.code.sf.net/p/flightgear/fgdata
	git://mapserver.flightgear.org/fgdata"
EGIT_BRANCH="next"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

# data files split to separate package since 2.10.0
RDEPEND="
	!<games-simulation/flightgear-2.10.0
"

src_install() {
	insinto /usr/share/flightgear
	rm -fr .git
	doins -r *
}
