# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libexif-gtk/libexif-gtk-0.3.5-r2.ebuild,v 1.9 2012/05/05 08:02:28 jdhore Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="GTK+ frontend to the libexif library (parsing, editing, and saving EXIF data)"
HOMEPAGE="http://libexif.sf.net"
SRC_URI="mirror://sourceforge/libexif/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="nls static-libs"

RDEPEND="x11-libs/gtk+:2
	>=media-libs/libexif-0.6.12"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-confcheck.patch \
		"${FILESDIR}"/${P}-gtk212.patch

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable nls)
}

src_install() {
	default
	rm -f "${ED}"usr/lib*/${PN}.la
}
