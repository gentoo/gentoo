# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.72.0
QTMIN=5.14.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org optfeature

DESCRIPTION="Plasma filemanager focusing on usability"
HOMEPAGE="https://kde.org/applications/system/org.kde.dolphin
https://userbase.kde.org/Dolphin"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="activities semantic-desktop"

DEPEND="
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kinit-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=media-libs/phonon-4.11.0
	activities? ( >=kde-frameworks/kactivities-${KFMIN}:5 )
	semantic-desktop? (
		>=kde-apps/baloo-widgets-${PVCUT}:5
		>=kde-frameworks/baloo-${KFMIN}:5
		>=kde-frameworks/kfilemetadata-${KFMIN}:5
	)
"
RDEPEND="${DEPEND}
	>=kde-apps/kio-extras-${PVCUT}:5
"

RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_PackageKitQt5=ON
		$(cmake_use_find_package activities KF5Activities)
		$(cmake_use_find_package semantic-desktop KF5Baloo)
		$(cmake_use_find_package semantic-desktop KF5BalooWidgets)
		$(cmake_use_find_package semantic-desktop KF5FileMetaData)
	)

	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Optional dependencies:"
		optfeature "compress/extract and other actions" kde-apps/ark:${SLOT}
		optfeature "crypto actions" kde-apps/kleopatra:${SLOT}
		optfeature "video file thumbnails" kde-apps/ffmpegthumbs:${SLOT}
		optfeature "graphics file thumbnails" kde-apps/thumbnailers:${SLOT}
		optfeature "'Share' context menu actions" kde-frameworks/purpose:${SLOT}
	fi
	ecm_pkg_postinst
}
