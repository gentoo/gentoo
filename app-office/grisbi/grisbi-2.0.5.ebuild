# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2

DESCRIPTION="Grisbi is a personal accounting application for Linux"
HOMEPAGE="http://www.grisbi.org https://github.com/grisbi/grisbi"
SRC_URI="mirror://sourceforge/${PN}/grisbi%20stable/$(ver_cut 1-2).x/${P}.tar.bz2"
IUSE="goffice nls ofx ssl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2:2
	gnome-extra/libgsf
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango
	x11-misc/xdg-utils
	ssl? ( >=dev-libs/openssl-1.0.0:0= )
	ofx? ( >=dev-libs/libofx-0.9.0:= )
	goffice? ( >=x11-libs/goffice-0.10.0 )
"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/intltool
	virtual/pkgconfig"

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
