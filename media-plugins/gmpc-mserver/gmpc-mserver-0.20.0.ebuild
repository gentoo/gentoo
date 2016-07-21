# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="This plugin allows you to play local files on a remote or local mpd
server"
HOMEPAGE="http://gmpc.wikia.com/wiki/GMPC_PLUGIN_MSERVER"
SRC_URI="mirror://sourceforge/musicpd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-sound/gmpc-${PV}
	dev-libs/libxml2
	media-libs/taglib
	net-libs/libmicrohttpd"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}
