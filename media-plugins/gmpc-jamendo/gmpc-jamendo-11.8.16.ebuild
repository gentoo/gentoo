# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gmpc-jamendo/gmpc-jamendo-11.8.16.ebuild,v 1.5 2014/08/10 21:05:53 slyfox Exp $

EAPI=4

DESCRIPTION="Plugin allows you to browse and preview music available on jamendo"
HOMEPAGE="http://gmpc.wikia.com/wiki/GMPC_PLUGIN_JAMENDO"
SRC_URI="http://download.sarine.nl/Programs/gmpc/11.8/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND=">=media-sound/gmpc-${PV}
	dev-db/sqlite:3
	dev-libs/libxml2:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/gob
	nls? ( dev-util/intltool
		sys-devel/gettext )"

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default
	find "${ED}" -name "*.la" -exec rm {} + || die
}
