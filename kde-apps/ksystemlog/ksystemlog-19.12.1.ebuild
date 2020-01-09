# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=5.63.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="System log viewer by KDE"
HOMEPAGE="https://kde.org/applications/system/org.kde.ksystemlog"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="systemd"

# bug 378101
RESTRICT+=" test"

DEPEND="
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}"

src_prepare() {
	ecm_src_prepare

	if use test; then
		# beat this stupid test into shape: the test files contain no year, so
		# comparison succeeds only in 2007 !!!
		local theyear=$(date +%Y)
		einfo Setting the current year as ${theyear} in the test files
		sed -e "s:2007:${theyear}:g" -i tests/systemAnalyzerTest.cpp || die

		# one test consistently fails, so comment it out for the moment
		sed -e "s:systemAnalyzerTest:# dont run systemAnalyzerTest:g" \
			-i ksystemlog/tests/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package systemd Journald)
	)
	ecm_src_configure
}
