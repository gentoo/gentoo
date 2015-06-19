# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/shivavg/shivavg-0.2.1.ebuild,v 1.3 2010/09/16 17:16:05 scarabeus Exp $

EAPI=3

MY_PN="ShivaVG"
MY_P="${MY_PN}-${PV}"
inherit base autotools

DESCRIPTION="open-source implementation of the Khronos' OpenVG specification"
HOMEPAGE="http://shivavg.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE=""

RDEPEND="virtual/glu
	media-libs/freeglut
	virtual/opengl"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	base_src_prepare

	sed -i -e 's:LDFLAGS="$LDFLAGS :LIBS=":g' \
		configure.in
	eautoreconf
}
