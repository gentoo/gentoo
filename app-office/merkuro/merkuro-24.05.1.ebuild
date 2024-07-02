# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="pim"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Calendar application using Akonadi"
HOMEPAGE="https://apps.kde.org/merkuro.calendar/"

LICENSE="|| ( GPL-2 GPL-3 ) CC0-1.0"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

# All of the tests involve interacting with akonadi right now (as of 22.04)
RESTRICT="test"

DEPEND="
	app-crypt/gpgme:=[cxx]
	dev-libs/kirigami-addons:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-apps/akonadi-${PVCUT}:6
	>=kde-apps/akonadi-contacts-${PVCUT}:6
	>=kde-apps/akonadi-mime-${PVCUT}:6
	>=kde-apps/kcalutils-${PVCUT}:6
	>=kde-apps/kidentitymanagement-${PVCUT}:6
	>=kde-apps/kmailtransport-${PVCUT}:6
	>=kde-apps/kmbox-${PVCUT}:6
	>=kde-apps/kmime-${PVCUT}:6
	>=kde-apps/mailcommon-${PVCUT}:6
	>=kde-apps/messagelib-${PVCUT}:6
	>=kde-apps/mimetreeparser-${PVCUT}:6
	>=kde-frameworks/kcalendarcore-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcontacts-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
# Qt5Compat.GraphicalEffects usage in multiple QML files
# qtlocation is needed at runtime only or fails to start
RDEPEND="${DEPEND}
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	>=dev-qt/qtlocation-${QTMIN}:6
	>=dev-qt/qtwebengine-${QTMIN}:6
	>=kde-apps/kdepim-runtime-${PVCUT}:6
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:6
"
