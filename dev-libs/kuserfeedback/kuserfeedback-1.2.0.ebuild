# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=5.82.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Framework to collect user feedback for applications via telemetry and surveys"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
fi
LICENSE="MIT"
SLOT="5"
IUSE="doc"

DEPEND="
	>=dev-qt/qtcharts-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	doc? (
		>=dev-qt/qdoc-${QTMIN}:5
		>=dev-qt/qthelp-${QTMIN}:5
	)
"

# https://invent.kde.org/libraries/kuserfeedback/-/merge_requests/21
PATCHES=( "${FILESDIR}/${P}-enable_docs.patch" )

src_configure() {
	local mycmakeargs=(
		-DQT_MAJOR_VERSION=5
		# disable server application
		-DENABLE_PHP=NO
		-DENABLE_PHP_UNIT=NO
		-DENABLE_SURVEY_TARGET_EXPRESSIONS=YES
		-DENABLE_DOCS=$(usex doc)
	)

	ecm_src_configure
}
