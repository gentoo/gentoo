# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gmpc-tagedit/gmpc-tagedit-11.8.16.ebuild,v 1.4 2012/05/05 08:27:16 jdhore Exp $

EAPI=4

DESCRIPTION="This plugin allows you to edit tags in your library"
HOMEPAGE="http://gmpc.wikia.com/wiki/GMPC_PLUGIN_TAGEDIT"
SRC_URI="mirror://sourceforge/musicpd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND=">=media-sound/gmpc-${PV}
	media-libs/taglib
	dev-libs/libxml2:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/gob
	nls? ( dev-util/intltool
		sys-devel/gettext )"

src_configure() {
	econf --disable-dependency-tracking
}

src_install() {
	default
	find "${ED}" -name "*.la" -exec rm {} + || die
}
