# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Grisbi is a personal accounting application for Linux"
HOMEPAGE="http://www.grisbi.org https://github.com/grisbi/grisbi"
SRC_URI="mirror://sourceforge/${PN}/grisbi%20stable/1.2.x/${P}.tar.bz2"
IUSE="goffice libressl nls ofx ssl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=dev-libs/libxml2-2.5:2
	>=dev-libs/glib-2.44.0:2
	>=x11-libs/gtk+-3.20:3
	x11-misc/xdg-utils
	>=gnome-extra/libgsf-1.14
	ssl? (
		libressl? ( dev-libs/libressl:0= )
		!libressl? ( >=dev-libs/openssl-1.0.0:0= ) )
	ofx? ( >=dev-libs/libofx-0.9.0 )
	goffice? ( >=x11-libs/goffice-0.10.0 )
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
		$(use_with goffice) \
		$(use_enable nls)
}
