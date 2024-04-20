# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="FlightGear data files"
HOMEPAGE="https://www.flightgear.org/"
EGIT_REPO_URI="git://git.code.sf.net/p/flightgear/fgdata
	git://mapserver.flightgear.org/fgdata"
EGIT_BRANCH="next"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

src_install() {
	insinto /usr/share/flightgear
	rm -fr .git
	doins -r *
}
