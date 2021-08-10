# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="C++ port of the Log for Java (log4j) logging library"
HOMEPAGE="http://log4cplus.sourceforge.net/ https://github.com/log4cplus/log4cplus"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}-stable/${PV}/${P}.tar.bz2"

LICENSE="|| ( Apache-2.0 BSD-2 )"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="explicit-initialization iconv qt5 server test threads"
RESTRICT="!test? ( test )"

RDEPEND="iconv? ( virtual/libiconv )
	qt5? ( dev-qt/qtcore:5 )"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DLOG4CPLUS_BUILD_LOGGINGSERVER=$(usex server)
		-DWITH_UNIT_TESTS=$(usex test)
		-DLOG4CPLUS_BUILD_TESTING=$(usex test)
		-DLOG4CPLUS_ENABLE_THREAD_POOL=$(usex threads)
		-DLOG4CPLUS_REQUIRE_EXPLICIT_INITIALIZATION=$(usex explicit-initialization)
		-DWITH_ICONV=$(usex iconv)
		-DLOG4CPLUS_QT5=$(usex qt5)
	)

	cmake_src_configure
}
