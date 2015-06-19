# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/librvp/librvp-0.9.6.ebuild,v 1.8 2014/08/05 18:34:11 mrueg Exp $

EAPI="2"

inherit multilib

DESCRIPTION="An RVP (Microsoft Exchange Instant Messaging) plugin for Pidgin"
HOMEPAGE="http://www.waider.ie/hacks/workshop/c/rvp/"
SRC_URI="http://www.waider.ie/hacks/workshop/c/rvp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="net-im/pidgin[gtk]"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

src_configure() {
	econf --with-gaim-plugin-dir=/usr/$(get_libdir)/pidgin \
		--with-gaim-data-dir=/usr/share/pixmaps/pidgin
}

src_install() {
	make install DESTDIR="${D}" || die "install failure"
	dodoc AUTHORS ChangeLog INSTALL NEWS README
}
