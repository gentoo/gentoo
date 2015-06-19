# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/libvisual-projectm/libvisual-projectm-2.0.1.ebuild,v 1.5 2012/05/08 07:28:41 nativemad Exp $

EAPI=4

inherit cmake-utils

MY_P=projectM_libvisual-${PV}-Source

DESCRIPTION="A libvisual graphical music visualization plugin similar to milkdrop"
HOMEPAGE="http://projectm.sourceforge.net"
SRC_URI="mirror://sourceforge/projectm/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="media-libs/libsdl
	=media-libs/libvisual-0.4*
	>=media-libs/libprojectm-2.0.1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS ChangeLog"

PATCHES=(
	"${FILESDIR}/${PV}-gcc4.6.patch"
)
