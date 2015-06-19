# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gmpc-avahi/gmpc-avahi-11.8.16.ebuild,v 1.5 2012/08/21 10:05:08 xmw Exp $

EAPI=4

DESCRIPTION="This plugin discovers avahi enabled mpd servers"
HOMEPAGE="http://gmpc.wikia.com/wiki/GMPC_PLUGIN_AVAHI"
SRC_URI="http://download.sarine.nl/Programs/gmpc/11.8/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND=">=media-sound/gmpc-${PV}
	dev-libs/libxml2
	net-dns/avahi[dbus]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( dev-util/intltool
		sys-devel/gettext )"

src_configure() {
	econf $(use_enable nls)
}

src_install () {
	default
	find "${ED}" -name "*.la" -exec rm {} + || die
}
