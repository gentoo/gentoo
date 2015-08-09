# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit autotools

DESCRIPTION="pidgin plugin to stop spammers from annoying you"
HOMEPAGE="http://code.google.com/p/pidgin-privacy-please/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="linguas_de linguas_pl linguas_ru"

RDEPEND="<net-im/pidgin-3[gtk]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	sed -e 's: -Wall -g3::' -i configure.ac || die
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" ALL_LINGUAS="${LANGS}" install || die
	dodoc AUTHORS ChangeLog NEWS README || die
}
