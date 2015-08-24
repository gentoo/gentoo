# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
CMAKE_MIN_VERSION="2.8.5"

inherit cmake-utils

DESCRIPTION="A simple, small, efficient, C++ XML parser"
HOMEPAGE="http://www.grinninglizard.com/tinyxml2/"
SRC_URI="https://dev.gentoo.org/~radhermit/distfiles/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs test"

PATCHES=(
	"${FILESDIR}"/${P}-test.patch
	"${FILESDIR}"/${PN}-1.0.1_p20120531-test-return-status.patch
)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build static-libs STATIC_LIBS)
		$(cmake-utils_use_build test TEST)
	)
	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_test
	./test || die "Tests failed"
}
