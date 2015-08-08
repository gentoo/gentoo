# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Show rdf Newsticker on TV"
HOMEPAGE="http://www.wontorra.net"
SRC_URI="http://www.wontorra.net/filemgmt_data/files/${P}.tar.gz"

KEYWORDS="~amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.2.6
	net-misc/wget"

PATCHES=( "${FILESDIR}/${P}-gcc4.diff" )

src_install() {
	vdr-plugin-2_src_install

	keepdir /var/vdr/newsticker
	chown vdr:vdr "${D}/var/vdr/newsticker"
}
