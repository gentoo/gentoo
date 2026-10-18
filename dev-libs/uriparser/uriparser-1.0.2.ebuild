# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake qt-utils

DESCRIPTION="Strictly RFC 3986 compliant URI parsing library in C"
HOMEPAGE="https://uriparser.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="test? ( LGPL-2.1+ ) BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ~ppc64 ~riscv ~sparc x86"
IUSE="doc qt6 test unicode"

REQUIRED_USE="qt6? ( doc ) test? ( unicode )"
RESTRICT="!test? ( test )"

DEPEND="
	test? ( >=dev-cpp/gtest-1.8.1 )
"
BDEPEND="
	virtual/pkgconfig
	doc? (
		>=app-text/doxygen-1.5.8
		media-gfx/graphviz
		qt6? ( dev-qt/qttools:6[assistant] )
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
	)

	if use doc; then
		if use qt6; then # bug #979154
			mycmakeargs+=( -DQHG_LOCATION="$(qt_get_broot_binary 6 qhelpgenerator)" )
		else
			mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Qt5Help=ON )
		fi
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use doc && use qt6; then
		dodoc "${BUILD_DIR}"/doc/*.qch
		docompress -x /usr/share/doc/${PF}/${P}.qch
	fi
}
