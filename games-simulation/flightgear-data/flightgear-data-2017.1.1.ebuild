# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="FlightGear data files"
HOMEPAGE="http://www.flightgear.org/"
SRC_URI="mirror://sourceforge/flightgear/FlightGear-${PV}-data.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

# data files split to separate package since 2.10.0
RDEPEND="
	!<games-simulation/flightgear-2.10.0
"

S=${WORKDIR}/fgdata

src_install() {
	insinto /usr/share/flightgear
	rm -fr .git
	doins -r *
}
