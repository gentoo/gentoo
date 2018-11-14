# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="This plugin sends an announcement to the notification daemon on song change"
HOMEPAGE="http://gmpc.wikia.com/wiki/GMPC_PLUGIN_LIBNOTIFY"
SRC_URI="mirror://sourceforge/musicpd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND=">=media-sound/gmpc-${PV}
	dev-libs/libxml2
	x11-libs/libnotify"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( dev-util/intltool
		sys-devel/gettext )"

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default
	find "${ED}" -name "*.la" -exec rm {} + || die
}
