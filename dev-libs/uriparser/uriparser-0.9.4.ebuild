# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Uriparser is a strictly RFC 3986 compliant URI parsing library in C"
HOMEPAGE="https://uriparser.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="doc qt5 test unicode"

RDEPEND=""
DEPEND="virtual/pkgconfig
	doc? ( >=app-doc/doxygen-1.5.8
		qt5? ( dev-qt/qthelp:5 ) )
	test? ( >=dev-cpp/gtest-1.8.1 )"

REQUIRED_USE="test? ( unicode )"
RESTRICT="!test? ( test )"

DOCS=( AUTHORS ChangeLog THANKS )

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DURIPARSER_BUILD_CHAR=ON
		-DURIPARSER_BUILD_DOCS=$(usex doc ON OFF)
		-DURIPARSER_BUILD_TESTS=$(usex test ON OFF)
		-DURIPARSER_BUILD_TOOLS=ON
		-DURIPARSER_BUILD_WCHAR_T=$(usex unicode ON OFF)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use doc && use qt5; then
		dodoc "${BUILD_DIR}"/doc/*.qch
		docompress -x /usr/share/doc/${PF}/${P}.qch
	fi
}
