# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Organizational assistant, providing calendars and other similar functionality"
HOMEPAGE="https://apps.kde.org/korganizer/"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~x86"
IUSE="telemetry"

# testkodaymatrix is broken, akonadi* tests need DBus, bug #665686
RESTRICT="test"

COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/akonadi-calendar-${PVCUT}:5
	>=kde-apps/akonadi-contacts-${PVCUT}:5
	>=kde-apps/akonadi-mime-${PVCUT}:5
	>=kde-apps/akonadi-notes-${PVCUT}:5
	>=kde-apps/calendarsupport-${PVCUT}:5
	>=kde-apps/eventviews-${PVCUT}:5
	>=kde-apps/incidenceeditor-${PVCUT}:5
	>=kde-apps/kcalutils-${PVCUT}:5
	>=kde-apps/kidentitymanagement-${PVCUT}:5
	>=kde-apps/kmailtransport-${PVCUT}:5
	>=kde-apps/kmime-${PVCUT}:5
	>=kde-apps/kontactinterface-${PVCUT}:5
	>=kde-apps/kpimtextedit-${PVCUT}:5
	>=kde-apps/libkdepim-${PVCUT}:5
	>=kde-apps/pimcommon-${PVCUT}:5
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kholidays-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	x11-libs/libX11
	telemetry? ( >=dev-libs/kuserfeedback-1.2.0:5 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/designer-${QTMIN}:5
	>=kde-apps/kldap-${PVCUT}:5
	test? ( >=kde-apps/akonadi-${PVCUT}:5[sqlite] )
"
RDEPEND="${COMMON_DEPEND}
	>=kde-apps/kdepim-runtime-${PVCUT}:5
"
BDEPEND="test? ( >=kde-apps/akonadi-${PVCUT}:5[tools] )"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package telemetry KUserFeedback)
	)

	ecm_src_configure
}
