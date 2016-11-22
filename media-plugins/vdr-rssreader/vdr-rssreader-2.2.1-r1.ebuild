# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: RSS reader"
HOMEPAGE="http://www.saunalahti.fi/~rahrenbe/vdr/rssreader/"
SRC_URI="http://www.saunalahti.fi/~rahrenbe/vdr/rssreader/files/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-2.2.0
		>=dev-libs/expat-1.95.8
		>=net-misc/curl-7.15.1-r1"

RDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}/${PN}-2.0.0-gentoo.diff"
		"${FILESDIR}/${P}_c++11.patch" )

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/rssreader
	doins "${S}/rssreader/rssreader.conf"
}
