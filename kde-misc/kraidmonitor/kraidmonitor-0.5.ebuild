# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="Indicator widget for raid arrays"
HOMEPAGE="http://kde-apps.org/content/show.php/K+Raid+Monitor?content=68553"
SRC_URI="http://kde-look.org/CONTENT/content-files/68553-${PN}_${PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	kde-plasma/plasma-workspace:4
"

S=${WORKDIR}/${PN}
