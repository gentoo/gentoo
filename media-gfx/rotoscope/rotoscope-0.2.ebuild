# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Graphics program that can be used to give photos a cartoon-like appearance"
HOMEPAGE="http://www.toonyphotos.com"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	>=gnome-base/libglade-2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
