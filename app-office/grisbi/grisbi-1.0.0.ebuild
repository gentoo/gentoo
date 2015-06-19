# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/grisbi/grisbi-1.0.0.ebuild,v 1.4 2014/05/04 12:09:47 pacho Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2

DESCRIPTION="Grisbi is a personal accounting application for Linux"
HOMEPAGE="http://www.grisbi.org"
SRC_URI="mirror://sourceforge/grisbi/grisbi%20stable/1.0.x/${P}.tar.bz2"
IUSE="nls ofx ssl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="dev-libs/libxml2
	>=dev-libs/glib-2.18.0:2
	>=x11-libs/gtk+-2.12.0:2
	x11-misc/xdg-utils
	ssl? ( >=dev-libs/openssl-0.9.5 )
	ofx? ( >=dev-libs/libofx-0.7.0 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	G2CONF+="--with-libxml2
		--without-cunit
		--disable-static
		$(use_with ssl openssl)
		$(use_with ofx)
		$(use_enable nls)"
	DOCS="AUTHORS NEWS README"
}
