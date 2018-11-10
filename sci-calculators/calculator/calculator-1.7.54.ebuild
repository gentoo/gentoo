# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fox

DESCRIPTION="Scientific calculator based on the FOX Toolkit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND="~x11-libs/fox-${PV}
	x11-libs/libICE
	x11-libs/libSM"
DEPEND="${RDEPEND}"
