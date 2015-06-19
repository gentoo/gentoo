# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gmock/gmock-1.4.0.ebuild,v 1.6 2012/08/28 21:52:08 vapier Exp $

EAPI="4"

inherit libtool eutils

DESCRIPTION="Google's C++ mocking framework"
HOMEPAGE="http://code.google.com/p/googlemock/"
SRC_URI="http://googlemock.googlecode.com/files/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs"

RDEPEND=">=dev-cpp/gtest-${PV}"
DEPEND="${RDEPEND}"

src_unpack() {
	default
	# make sure we always use the system one
	rm -r "${S}"/gtest/Makefile* || die
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc-4.7.patch
	epatch "${FILESDIR}"/${P}-more-gcc-4.7.patch
	elibtoolize
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${ED}"/usr -name '*.la' -delete
}
