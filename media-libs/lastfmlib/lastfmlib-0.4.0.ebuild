# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/lastfmlib/lastfmlib-0.4.0.ebuild,v 1.5 2012/05/05 08:02:26 jdhore Exp $

EAPI=2

DESCRIPTION="C++ library to scrobble tracks on Last.fm"
HOMEPAGE="http://code.google.com/p/lastfmlib/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug syslog"

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-static \
		$(use_enable debug) \
		$(use_enable syslog logging) \
		--disable-unittests
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog
	find "${D}"/usr -name '*.la' -delete
}
