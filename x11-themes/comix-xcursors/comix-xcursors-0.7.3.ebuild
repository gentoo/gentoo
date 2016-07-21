# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="ComixCursors"

DESCRIPTION="X11 mouse theme with a comics feeling"
HOMEPAGE="http://kde-look.org/content/show.php/ComixCursors?content=32627"
SRC_URI="http://www.limitland.de/comixcursors/${MY_PN}-${PV}.tar.bz2
	lefthanded? ( http://www.limitland.de/comixcursors/${MY_PN}-LH-${PV}.tar.bz2 )
	opaque? ( http://www.limitland.de/comixcursors/${MY_PN}-Opaque-${PV}.tar.bz2 )
	lefthanded? ( opaque? ( http://www.limitland.de/comixcursors/${MY_PN}-LH-Opaque-${PV}.tar.bz2 ) )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="lefthanded opaque"

RDEPEND="x11-libs/libX11
	x11-libs/libXcursor"
DEPEND=""

S="${WORKDIR}"

src_install() {
	insinto "/usr/share/cursors/xorg-x11"
	doins -r "${S}"/*
}
