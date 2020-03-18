# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Show rdf Newsticker on TV"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://vdr.websitec.de/download/${PN}/${P}.tar.gz"

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
