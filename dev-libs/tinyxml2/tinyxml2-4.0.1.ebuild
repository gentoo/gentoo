# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="A simple, small, efficient, C++ XML parser"
HOMEPAGE="http://www.grinninglizard.com/tinyxml2/ https://github.com/leethomason/tinyxml2/"
SRC_URI="https://github.com/leethomason/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/4"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs test"

PATCHES=(
	"${FILESDIR}"/${P}-optional-tests.patch
	"${FILESDIR}"/${P}-xmltest.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DBUILD_TEST=$(usex test)
	)
	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_test
	./xmltest || die "Tests failed"
}
