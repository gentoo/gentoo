# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="FlightGear data files"
HOMEPAGE="https://www.flightgear.org/"
SRC_URI="https://download.flightgear.org/release-2024.1/FlightGear-${PV}-data.txz"

S=${WORKDIR}/fgdata_$(ver_cut 1)_$(ver_cut 2)

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	insinto /usr/share/flightgear
	rm -fr .git
	doins -r *
}
