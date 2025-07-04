# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for providing spell-checking through abstraction of popular backends"

LICENSE="LGPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="aspell +hunspell qml"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	aspell? ( app-text/aspell )
	hunspell? ( app-text/hunspell:= )
	qml? ( >=dev-qt/qtdeclarative-${QTMIN}:6 )
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

CMAKE_SKIP_TESTS=(
	# bug 779994
	sonnet-test_autodetect
	# bug 680032
	sonnet-test_settings
	sonnet-test_highlighter
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package aspell ASPELL)
		$(cmake_use_find_package hunspell HUNSPELL)
		-DSONNET_USE_QML=$(usex qml)
	)
	if ! use aspell && ! use hunspell; then
		mycmakeargs+=( -DSONNET_NO_BACKENDS=ON )
	fi

	ecm_src_configure
}
