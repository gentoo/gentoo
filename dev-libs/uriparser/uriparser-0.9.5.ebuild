# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Strictly RFC 3986 compliant URI parsing library in C"
HOMEPAGE="https://uriparser.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="+doc qt5 test unicode"  # +doc to address warning RequiredUseDefaults

REQUIRED_USE="qt5? ( doc ) test? ( unicode )"
RESTRICT="!test? ( test )"

DEPEND="
	test? ( >=dev-cpp/gtest-1.8.1 )
"
BDEPEND="
	virtual/pkgconfig
	doc? (
		>=app-doc/doxygen-1.5.8
		media-gfx/graphviz
		qt5? ( dev-qt/qthelp:5 )
	)
"

DOCS=( AUTHORS ChangeLog THANKS )

src_configure() {
	local mycmakeargs=(
		-DURIPARSER_BUILD_CHAR=ON
		-DURIPARSER_BUILD_DOCS=$(usex doc ON OFF)
		-DURIPARSER_BUILD_TESTS=$(usex test ON OFF)
		-DURIPARSER_BUILD_TOOLS=ON
		-DURIPARSER_BUILD_WCHAR_T=$(usex unicode ON OFF)

		# The usex wrapper is here to address this warning:
		#   One or more CMake variables were not used by the project:
		#   CMAKE_DISABLE_FIND_PACKAGE_Qt5Help
		$(usex doc "$(cmake_use_find_package qt5 Qt5Help)")
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use doc && use qt5; then
		dodoc "${BUILD_DIR}"/doc/*.qch
		docompress -x /usr/share/doc/${PF}/${P}.qch
	fi
}
