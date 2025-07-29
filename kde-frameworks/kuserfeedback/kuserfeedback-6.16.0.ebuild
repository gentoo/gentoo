# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
ECM_TEST="forceoptional"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework to collect user feedback for applications via telemetry and surveys"

LICENSE="MIT"
KEYWORDS="~amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="doc tools"

# FIXME: Qt_6_PRIVATE_API matches UserFeedbackConsole, but where is it coming from?
DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,widgets]
	>=dev-qt/qtcharts-${QTMIN}:6
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5[-kf6compat(-)]
"
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
	doc? ( >=dev-qt/qttools-${QTMIN}:6[assistant,qdoc,linguist] )
"

src_configure() {
	local mycmakeargs=(
		# disable server application
		-DENABLE_PHP=NO
		-DENABLE_PHP_UNIT=NO
		-DENABLE_SURVEY_TARGET_EXPRESSIONS=YES
		-DENABLE_DOCS=$(usex doc)
		-DENABLE_CONSOLE=$(usex tools)
	)

	ecm_src_configure
}

CMAKE_SKIP_TESTS=(
	# bugs: 921359, requires virtualx
	openglinfosourcetest
)
