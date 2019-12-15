# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_DESIGNERPLUGIN="true"
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework for providing spell-checking through abstraction of popular backends"
LICENSE="LGPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="aspell +hunspell nls"

BDEPEND="
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"
DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	aspell? ( app-text/aspell )
	hunspell? ( app-text/hunspell:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package aspell ASPELL)
		$(cmake_use_find_package hunspell HUNSPELL)
	)

	ecm_src_configure
}

src_test() {
	# bugs: 680032
	local myctestargs=(
		-E "(sonnet-test_settings|sonnet-test_highlighter)"
	)

	ecm_src_test
}
