# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit libtool

DESCRIPTION="Google's C++ mocking framework"
HOMEPAGE="https://code.google.com/p/googlemock/"
SRC_URI="https://googlemock.googlecode.com/files/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE="static-libs"

RDEPEND="=dev-cpp/gtest-${PV}*"
DEPEND="app-arch/unzip
	${RDEPEND}"

src_unpack() {
	default
	# make sure we always use the system one
	rm -r "${S}"/gtest/{Makefile,configure}* || die
}

src_prepare() {
	sed -i -r \
		-e '/^install-(data|exec)-local:/s|^.*$|&\ndisabled-&|' \
		Makefile.in
	elibtoolize
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	dobin scripts/gmock-config
	use static-libs || find "${D}" -name '*.la' -delete
}
