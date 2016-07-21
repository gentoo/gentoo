# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils

MY_P=projectM-complete-${PV}-Source

DESCRIPTION="A libvisual graphical music visualization plugin similar to milkdrop"
HOMEPAGE="http://projectm.sourceforge.net"
SRC_URI="mirror://sourceforge/projectm/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
	media-libs/libsdl
	=media-libs/libvisual-0.4*
	>=media-libs/libprojectm-2.1.0
	virtual/opengl
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}/src/projectM-libvisual/

DOCS="AUTHORS ChangeLog"
