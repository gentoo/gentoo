# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.7.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="News feed aggregator"
HOMEPAGE="https://apps.kde.org/akregator/"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="activities speech telemetry"

RDEPEND="
	>=dev-libs/ktextaddons-1.5.4:6[speech?]
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets,xml]
	>=dev-qt/qtwebengine-${QTMIN}:6[widgets]
	>=kde-apps/grantleetheme-${PVCUT}:6
	>=kde-apps/kontactinterface-${PVCUT}:6
	>=kde-apps/libkdepim-${PVCUT}:6
	>=kde-apps/messagelib-${PVCUT}:6
	>=kde-apps/pimcommon-${PVCUT}:6[activities?]
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/syndication-${KFMIN}:6
	activities? ( kde-plasma/plasma-activities:6 )
	telemetry? ( >=kde-frameworks/kuserfeedback-${KFMIN}:6 )
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DOPTION_USE_PLASMA_ACTIVITIES=$(usex activities)
		$(cmake_use_find_package speech KF6TextEditTextToSpeech)
		$(cmake_use_find_package telemetry KF6UserFeedback)
	)

	ecm_src_configure
}
