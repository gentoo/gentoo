# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gmock/gmock-1.5.0.ebuild,v 1.5 2012/06/12 18:58:16 jdhore Exp $

EAPI="4"

inherit libtool

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
	elibtoolize
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${D}" -name '*.la' -delete
}
