# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/tinyxml2/tinyxml2-2.2.0.ebuild,v 1.3 2015/02/15 19:08:55 zlogene Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="A simple, small, efficient, C++ XML parser"
HOMEPAGE="http://www.grinninglizard.com/tinyxml2/ https://github.com/leethomason/tinyxml2/"
SRC_URI="https://github.com/leethomason/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/2"
KEYWORDS="amd64 ~arm x86"
IUSE="static-libs test"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.9_p20121123-test.patch
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
