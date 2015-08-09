# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools eutils

DESCRIPTION="Tools and a library for creating flame fractal images"
HOMEPAGE="http://flam3.com/"
SRC_URI="http://flam3.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="dev-libs/libxml2
	media-libs/libpng
	virtual/jpeg
	!<=x11-misc/electricsheep-2.6.8-r2"
DEPEND="${RDEPEND}"

S=${S}/src

DOCS=( README.txt )

src_prepare() {
	epatch "${FILESDIR}"/${P}-libpng15.patch
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.in || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	default

	rm -f "${D}"usr/lib*/libflam3.la

	docinto examples
	dodoc *.flam3
}
