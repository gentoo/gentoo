# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Touchscreen calibration utility"
HOMEPAGE="http://touchcal.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	sys-libs/ncurses:0=
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXinerama
"
RDEPEND="${DEPEND}"
