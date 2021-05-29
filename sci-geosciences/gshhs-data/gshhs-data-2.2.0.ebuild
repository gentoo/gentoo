# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Global Self-consistent, Hierarchical, High-resolution Shoreline programs data"
HOMEPAGE="https://www.ngdc.noaa.gov/mgg/shorelines/gshhs.html"
SRC_URI="https://www.ngdc.noaa.gov/mgg/shorelines/data/gshhg/oldversions/version${PV}/gshhs+wdbii_${PV}.zip"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

src_install() {
	dodoc gshhs/README.TXT
	rm gshhs/README.TXT || die
	insinto /usr/share
	doins -r *
}
