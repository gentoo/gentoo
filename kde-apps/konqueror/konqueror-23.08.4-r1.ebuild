# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
KFMIN=5.106.0
QTMIN=5.15.9
inherit flag-o-matic ecm gear.kde.org optfeature

DESCRIPTION="Web browser and file manager based on KDE Frameworks"
HOMEPAGE="https://apps.kde.org/konqueror/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 arm64 ~x86"
IUSE="activities speech"

# 4 of 4 tests fail. Last checked for 4.0.3
RESTRICT="test"

COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdesu-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kinit-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	sys-libs/zlib
	speech? ( >=dev-qt/qtspeech-${QTMIN}:5 )
"
DEPEND="${COMMON_DEPEND}
	activities? ( >=kde-plasma/plasma-activities-${KFMIN}:5 )
"
RDEPEND="${COMMON_DEPEND}
	kde-apps/kfind:5
	kde-plasma/kde-cli-tools:*
"

src_prepare() {
	[[ ${CHOST} == *-solaris* ]] && append-ldflags -lmalloc

	ecm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Hunspell=ON # requires fixing bug 634122
		$(cmake_use_find_package activities KF5Activities)
		$(cmake_use_find_package speech Qt5TextToSpeech)
	)
	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "bookmarks support" kde-apps/keditbookmarks:${SLOT}
		optfeature "filemanager component" kde-apps/dolphin:${SLOT}
		optfeature "SVG support" kde-apps/svg:${SLOT}
	fi
	ecm_pkg_postinst
}
