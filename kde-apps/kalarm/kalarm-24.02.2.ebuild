# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.0.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Application to manage alarms and other timer based alerts for the desktop"
HOMEPAGE="https://apps.kde.org/kalarm/ https://userbase.kde.org/KAlarm"

LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
SLOT="6"
KEYWORDS="~amd64"
IUSE="+pim speech X"

DEPEND="
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets]
	>=kde-apps/kcalutils-${PVCUT}:6
	>=kde-apps/kidentitymanagement-${PVCUT}:6
	>=kde-apps/kmime-${PVCUT}:6
	>=kde-frameworks/kauth-${KFMIN}:6
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcontacts-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/kholidays-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X?]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	media-libs/libcanberra
	pim? (
		>=kde-apps/akonadi-${PVCUT}:6
		>=kde-apps/akonadi-contacts-${PVCUT}:6
		>=kde-apps/akonadi-mime-${PVCUT}:6
		>=kde-apps/kmailtransport-${PVCUT}:6
	)
	speech? ( dev-libs/ktextaddons:6[speech] )
	X? ( x11-libs/libX11 )
"
RDEPEND="${DEPEND}
	pim? ( >=kde-apps/kdepim-runtime-${PVCUT}:6 )
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_AKONADI_PLUGIN=$(usex pim)
		$(cmake_use_find_package speech KF6TextEditTextToSpeech)
		-DWITHOUT_X11=$(usex !X)
	)

	ecm_src_configure
}

src_test() {
	# LC_TIME bug 665626, 857012
	# TZ bug https://bugs.kde.org/show_bug.cgi?id=445734
	LC_TIME="C" TZ=UTC ecm_src_test
}
