# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="FlightGear data files"
HOMEPAGE="https://www.flightgear.org/"
EGIT_REPO_URI="https://gitlab.com/flightgear/fgdata.git"
EGIT_BRANCH="next"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

src_install() {
	insinto /usr/share/flightgear
	rm -fr .git
	doins -r *
}
