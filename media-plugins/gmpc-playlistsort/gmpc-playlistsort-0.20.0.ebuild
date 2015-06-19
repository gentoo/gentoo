# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gmpc-playlistsort/gmpc-playlistsort-0.20.0.ebuild,v 1.5 2012/05/05 08:27:18 jdhore Exp $

EAPI=3

DESCRIPTION="This plugin adds a dialog to sort the current playlist"
HOMEPAGE="http://gmpc.wikia.com/"
SRC_URI="mirror://sourceforge/musicpd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=media-sound/gmpc-${PV}
	>=gnome-base/libglade-2
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die
	find "${ED}" -name "*.la" -delete || die
}
