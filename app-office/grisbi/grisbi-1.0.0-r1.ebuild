# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Grisbi is a personal accounting application for Linux"
HOMEPAGE="http://www.grisbi.org"
SRC_URI="mirror://sourceforge/grisbi/grisbi%20stable/1.0.x/${P}.tar.bz2"
IUSE="libressl nls ofx ssl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	dev-libs/libxml2:2
	>=dev-libs/glib-2.18.0:2
	>=x11-libs/gtk+-2.12.0:2
	x11-misc/xdg-utils
	ssl? (
		libressl? ( dev-libs/libressl:0= )
		!libressl? ( >=dev-libs/openssl-0.9.5:0= ) )
	ofx? ( >=dev-libs/libofx-0.7.0 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--with-libxml2 \
		--without-cunit \
		--disable-static \
		$(use_with ssl openssl) \
		$(use_with ofx) \
		$(use_enable nls)
}
