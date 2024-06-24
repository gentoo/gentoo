# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
ECM_TEST="forceoptional"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm kde.org

DESCRIPTION="Framework to collect user feedback for applications via telemetry and surveys"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

LICENSE="MIT"
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="doc kf6compat"

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	!kf6compat? (
		>=dev-qt/qtcharts-${QTMIN}:5
		>=dev-qt/qtprintsupport-${QTMIN}:5
		>=dev-qt/qtwidgets-${QTMIN}:5
	)
"
RDEPEND="${DEPEND}
	kf6compat? ( kde-frameworks/kuserfeedback:6 )
"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
	>=dev-qt/linguist-tools-${QTMIN}:5
	doc? (
		>=dev-qt/qdoc-${QTMIN}:5
		>=dev-qt/qthelp-${QTMIN}:5
	)
"

PATCHES=( "${FILESDIR}/${P}-missing-include.patch" )

src_configure() {
	local mycmakeargs=(
		# disable server application
		-DENABLE_PHP=NO
		-DENABLE_PHP_UNIT=NO
		-DENABLE_SURVEY_TARGET_EXPRESSIONS=YES
		-DENABLE_DOCS=$(usex doc)
		-DENABLE_CLI=$(usex !kf6compat)
		-DENABLE_CONSOLE=$(usex !kf6compat)
	)

	ecm_src_configure
}

CMAKE_SKIP_TESTS=(
	# bugs: 921359, requires virtualx
	openglinfosourcetest
)
