# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="C library for encoding data in a QR Code symbol"
HOMEPAGE="http://fukuchi.org/works/qrencode/"
SRC_URI="http://fukuchi.org/works/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/libpng:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-3.2.0-pngregenfix.patch" )

src_prepare() {
	default
	eautoreconf
}
