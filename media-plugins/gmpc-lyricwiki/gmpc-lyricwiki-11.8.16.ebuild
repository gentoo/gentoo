# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gmpc-lyricwiki/gmpc-lyricwiki-11.8.16.ebuild,v 1.4 2012/05/05 08:27:18 jdhore Exp $

EAPI=4

DESCRIPTION="This plugin uses lyricwiki to fetch lyrics"
HOMEPAGE="http://gmpc.wikia.com/wiki/GMPC_PLUGIN_LYRICWIKI"
SRC_URI="mirror://sourceforge/musicpd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="nls"

RDEPEND=">=media-sound/gmpc-${PV}
	dev-libs/libxml2"
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
