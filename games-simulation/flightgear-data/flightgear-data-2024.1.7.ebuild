# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=$(ver_cut 1-2)
DESCRIPTION="FlightGear data files"
HOMEPAGE="https://www.flightgear.org/"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/flightgear/fgdata.git"
	EGIT_BRANCH="next"
else
	SRC_URI="https://download.flightgear.org/release-${MY_PV}/FlightGear-${PV}-data.txz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/fgdata_${MY_PV/./_}"
fi
LICENSE="GPL-2"
SLOT="0"

src_install() {
	insinto /usr/share/flightgear
	doins -r *
}
