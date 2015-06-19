# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gmpc-extraplaylist/gmpc-extraplaylist-0.20.0.ebuild,v 1.6 2012/05/05 08:27:18 jdhore Exp $

EAPI=3

DESCRIPTION="This plugin adds a second pane showing the playlist"
HOMEPAGE="http://gmpc.wikia.com/wiki/GMPC_PLUGIN_EXTRA_PLAYLIST"
SRC_URI="mirror://sourceforge/musicpd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=media-sound/gmpc-${PV}
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install () {
	emake DESTDIR="${D}" install || die
	find "${ED}" -name "*.la" -delete || die
}
