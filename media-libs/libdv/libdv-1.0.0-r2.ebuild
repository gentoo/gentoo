# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdv/libdv-1.0.0-r2.ebuild,v 1.14 2012/05/17 14:19:31 aballier Exp $

EAPI=4

inherit eutils libtool

DESCRIPTION="Software codec for dv-format video (camcorders etc)"
HOMEPAGE="http://libdv.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/${PN}-1.0.0-pic.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug sdl static-libs xv"

RDEPEND="dev-libs/popt
	sdl? ( >=media-libs/libsdl-1.2.5 )
	xv? ( x11-libs/libXv )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog INSTALL NEWS TODO )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.99-2.6.patch
	epatch "${WORKDIR}"/${PN}-1.0.0-pic.patch
	elibtoolize
	epunt_cxx #74497
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with debug) \
		--disable-gtk \
		--disable-gtktest \
		$(use_enable sdl) \
		$(use_enable xv)
}

src_install() {
	default

	find "${ED}" -name '*.la' -exec rm -f {} +
}
