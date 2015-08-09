# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Global Self-consistent, Hierarchical, High-resolution Shoreline programs data"
HOMEPAGE="http://www.ngdc.noaa.gov/mgg/shorelines/gshhs.html"
SRC_URI="http://www.ngdc.noaa.gov/mgg/shorelines/data/gshhs/version${PV}/gshhs+wdbii_${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
S="${WORKDIR}"

src_install() {
	dodoc gshhs/README.TXT
	rm gshhs/README.TXT || die
	insinto /usr/share
	doins -r *
}
