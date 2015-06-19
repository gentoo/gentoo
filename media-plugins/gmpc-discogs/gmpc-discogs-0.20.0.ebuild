# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gmpc-discogs/gmpc-discogs-0.20.0.ebuild,v 1.7 2012/05/05 08:27:20 jdhore Exp $

EAPI=3

DESCRIPTION="This plugin fetches artist and album images from discogs"
HOMEPAGE="http://gmpc.wikia.com/wiki/GMPC_PLUGIN_DISCOGS"
SRC_URI="mirror://sourceforge/musicpd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-sound/gmpc-${PV}
	dev-libs/libxml2
	|| ( x11-libs/gdk-pixbuf:2[jpeg] x11-libs/gtk+:2[jpeg] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	find "${ED}" -name "*.la" -delete || die
}
