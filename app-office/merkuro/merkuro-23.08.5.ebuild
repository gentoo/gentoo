# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="pim"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-3)
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="Calendar application using Akonadi"
HOMEPAGE="https://apps.kde.org/merkuro.calendar/"

LICENSE="|| ( GPL-2 GPL-3 ) CC0-1.0"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~x86"
IUSE=""

# All of the tests involve interacting with akonadi right now (as of 22.04)
RESTRICT="test"

DEPEND="
	app-crypt/gpgme:=[cxx]
	>=dev-libs/kirigami-addons-0.7.2:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=kde-apps/akonadi-${PVCUT}:5
	>=kde-apps/akonadi-contacts-${PVCUT}:5
	>=kde-apps/akonadi-mime-${PVCUT}:5
	>=kde-apps/kcalutils-${PVCUT}:5
	>=kde-apps/kidentitymanagement-${PVCUT}:5
	>=kde-apps/mailcommon-${PVCUT}:5
	>=kde-frameworks/kcalendarcore-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcontacts-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
"
# qtlocation is needed at runtime only or fails to start
RDEPEND="${DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtlocation-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5
	>=kde-apps/kdepim-runtime-${PVCUT}:5
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:5
"
